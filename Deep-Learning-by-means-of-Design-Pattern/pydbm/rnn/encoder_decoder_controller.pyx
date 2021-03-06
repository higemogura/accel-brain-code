# -*- coding: utf-8 -*-
from logging import getLogger
import numpy as np
cimport numpy as np
from pydbm.rnn.interface.reconstructable_model import ReconstructableModel
from pydbm.loss.interface.computable_loss import ComputableLoss
from pydbm.verification.interface.verificatable_result import VerificatableResult
ctypedef np.float64_t DOUBLE_t


class EncoderDecoderController(object):
    '''
    Encoder/Decoder based on LSTM networks.
    '''
    
    def __init__(
        self,
        encoder,
        decoder,
        int epochs,
        int batch_size,
        double learning_rate,
        double learning_attenuate_rate,
        int attenuate_epoch,
        double test_size_rate=0.3,
        computable_loss=None,
        verificatable_result=None,
        tol=1e-04
    ):
        '''
        Init.
        
        Args:
            encoder:                        is-a `ReconstructableModel`.
            decoder:                        is-a `ReconstructableModel`.
            epochs:                         Epochs of Mini-batch.
            bath_size:                      Batch size of Mini-batch.
            learning_rate:                  Learning rate.
            learning_attenuate_rate:        Attenuate the `learning_rate` by a factor of this value every `attenuate_epoch`.
            attenuate_epoch:                Attenuate the `learning_rate` by a factor of `learning_attenuate_rate` every `attenuate_epoch`.
                                            Additionally, in relation to regularization,
                                            this class constrains weight matrixes every `attenuate_epoch`.

            test_size_rate:                 Size of Test data set. If this value is `0`, the validation will not be executed.
            computable_loss:                Loss function.
            verificatable_result:           Verification function.
            tol:                            Tolerance for the optimization.
                                            When the loss or score is not improving by at least tol 
                                            for two consecutive iterations, convergence is considered 
                                            to be reached and training stops.

        '''
        if isinstance(encoder, ReconstructableModel) is False:
            raise TypeError()
        if isinstance(decoder, ReconstructableModel) is False:
            raise TypeError()
        if isinstance(computable_loss, ComputableLoss) is False:
            raise TypeError()
        if isinstance(verificatable_result, VerificatableResult) is False:
            raise TypeError()

        self.__encoder = encoder
        self.__decoder = decoder
        self.__computable_loss = computable_loss

        self.__epochs = epochs
        self.__batch_size = batch_size

        self.__learning_rate = learning_rate
        self.__learning_attenuate_rate = learning_attenuate_rate
        self.__attenuate_epoch = attenuate_epoch
        self.__test_size_rate = test_size_rate

        self.__verificatable_result = verificatable_result

        self.__tol = tol

        logger = getLogger("pydbm")
        self.__logger = logger

    def learn(self, np.ndarray[DOUBLE_t, ndim=3] observed_arr, np.ndarray target_arr=np.array([])):
        '''
        Learn the observed data points
        for vector representation of the input time-series.

        Override.

        Args:
            observed_arr:    Array like or sparse matrix as the observed data ponts.
            target_arr:      Array like or sparse matrix as the target data points.
                             To learn as Auto-encoder, this value must be `None` or equivalent to `observed_arr`.
        '''
        cdef double learning_rate = self.__learning_rate
        cdef int epoch
        cdef int batch_index

        cdef int row_o = observed_arr.shape[0]
        cdef int row_t = target_arr.shape[0]

        cdef np.ndarray train_index
        cdef np.ndarray test_index
        cdef np.ndarray[DOUBLE_t, ndim=3] train_observed_arr
        cdef np.ndarray train_target_arr
        cdef np.ndarray[DOUBLE_t, ndim=3] test_observed_arr
        cdef np.ndarray test_target_arr

        cdef np.ndarray rand_index
        cdef np.ndarray[DOUBLE_t, ndim=3] batch_observed_arr
        cdef np.ndarray batch_target_arr

        if row_t != 0 and row_t != row_o:
            raise ValueError("The row of `target_arr` must be equivalent to the row of `observed_arr`.")

        if row_t == 0:
            target_arr = observed_arr.copy()
        else:
            if target_arr.ndim == 2:
                target_arr = target_arr.reshape((target_arr.shape[0], 1, target_arr.shape[1]))

        if self.__test_size_rate > 0:
            train_index = np.random.choice(observed_arr.shape[0], round((1 - self.__test_size_rate) * observed_arr.shape[0]), replace=False)
            test_index = np.array(list(set(range(observed_arr.shape[0])) - set(train_index)))
            train_observed_arr = observed_arr[train_index]
            test_observed_arr = observed_arr[test_index]
            train_target_arr = target_arr[train_index]
            test_target_arr = target_arr[test_index]
        else:
            train_observed_arr = observed_arr
            train_target_arr = target_arr

        cdef double loss
        cdef double test_loss
        cdef np.ndarray[DOUBLE_t, ndim=3] hidden_activity_arr
        cdef np.ndarray[DOUBLE_t, ndim=3] test_hidden_activity_arr
        cdef np.ndarray[DOUBLE_t, ndim=2] encoded_arr
        cdef np.ndarray[DOUBLE_t, ndim=2] test_encoded_arr
        cdef np.ndarray[DOUBLE_t, ndim=2] decoded_arr
        cdef np.ndarray[DOUBLE_t, ndim=2] test_decoded_arr
        cdef np.ndarray[DOUBLE_t, ndim=2] delta_arr
        cdef np.ndarray[DOUBLE_t, ndim=3] encoder_delta_arr
        cdef np.ndarray[DOUBLE_t, ndim=3] decoder_delta_arr

        try:
            self.__memory_tuple_list = []
            eary_stop_flag = False
            loss_list = []
            for epoch in range(self.__epochs):
                if ((epoch + 1) % self.__attenuate_epoch == 0):
                    learning_rate = learning_rate / self.__learning_attenuate_rate

                rand_index = np.random.choice(train_observed_arr.shape[0], size=self.__batch_size)
                batch_observed_arr = train_observed_arr[rand_index]
                batch_target_arr = train_target_arr[rand_index]
                try:
                    encoded_arr = self.__encoder.inference(batch_observed_arr)
                    decoded_arr = self.__decoder.inference(
                        self.__encoder.get_feature_points()[:, ::-1, :]
                    )
                    hidden_activity_arr = self.__decoder.get_feature_points()[:, ::-1, :]
                    ver_hidden_activity_arr = hidden_activity_arr.copy()
                    delta_arr = self.__computable_loss.compute_delta(
                        hidden_activity_arr[:, 0, :],
                        batch_target_arr[:, 0, :]
                    )
                    loss = self.__computable_loss.compute_loss(
                        hidden_activity_arr[:, 0, :],
                        batch_target_arr[:, 0, :]
                    )
                    decoder_delta_arr, decoder_lstm_grads_list = self.__decoder.hidden_back_propagate(
                        delta_arr
                    )
                    encoder_delta_arr, encoder_lstm_grads_list = self.__encoder.hidden_back_propagate(
                        decoder_delta_arr[:, 0, :]
                    )
                    decoder_grads_list = [None, None]
                    [decoder_grads_list.append(d) for d in decoder_lstm_grads_list]
                    encoder_grads_list = [None, None]
                    [encoder_grads_list.append(d) for d in encoder_lstm_grads_list]

                    self.__decoder.optimize(decoder_grads_list, learning_rate, epoch)
                    self.__encoder.optimize(encoder_grads_list, learning_rate, epoch)

                    self.__encoder.graph.hidden_activity_arr = np.array([])
                    self.__encoder.graph.rnn_activity_arr = np.array([])
                    self.__decoder.graph.hidden_activity_arr = np.array([])
                    self.__decoder.graph.rnn_activity_arr = np.array([])

                except FloatingPointError:
                    if epoch > int(self.__epochs * 0.7):
                        self.__logger.debug(
                            "Underflow occurred when the parameters are being updated. Because of early stopping, this error is catched and the parameter is not updated."
                        )
                        eary_stop_flag = True
                        break
                    else:
                        self.__logger.debug(
                            "Underflow occurred when the parameters are being updated."
                        )
                        raise

                if self.__test_size_rate > 0:
                    rand_index = np.random.choice(test_observed_arr.shape[0], size=self.__batch_size)
                    test_batch_observed_arr = test_observed_arr[rand_index]
                    test_batch_target_arr = test_target_arr[rand_index]

                    test_encoded_arr = self.__encoder.inference(test_batch_observed_arr)
                    test_decoded_arr = self.__decoder.inference(
                        self.__encoder.get_feature_points()[:, ::-1, :]
                    )
                    test_hidden_activity_arr = self.__decoder.get_feature_points()[:, ::-1, :]
                    if self.__verificatable_result is not None:
                        if self.__test_size_rate > 0:
                            self.__verificatable_result.verificate(
                                self.__computable_loss,
                                train_pred_arr=ver_hidden_activity_arr[:, 0, :], 
                                train_label_arr=batch_target_arr[:, 0, :],
                                test_pred_arr=test_hidden_activity_arr[:, 0, :],
                                test_label_arr=test_batch_target_arr[:, 0, :]
                            )
                    self.__encoder.graph.hidden_activity_arr = np.array([])
                    self.__encoder.graph.rnn_activity_arr = np.array([])
                    self.__decoder.graph.hidden_activity_arr = np.array([])
                    self.__decoder.graph.rnn_activity_arr = np.array([])

                if epoch > 1 and abs(loss - loss_list[-1]) < self.__tol:
                    eary_stop_flag = True
                    break
                loss_list.append(loss)

        except KeyboardInterrupt:
            self.__logger.debug("Interrupt.")

        if eary_stop_flag is True:
            self.__logger.debug("Early stopping.")
            eary_stop_flag = False

        self.__logger.debug("end. ")

    def inference(
        self,
        np.ndarray[DOUBLE_t, ndim=3] observed_arr,
        np.ndarray[DOUBLE_t, ndim=2] hidden_activity_arr=None,
        np.ndarray[DOUBLE_t, ndim=2] rnn_activity_arr=None
    ):
        r'''
        Inference the feature points to reconstruct the time-series.

        Override.

        Args:
            observed_arr:           Array like or sparse matrix as the observed data ponts.
            hidden_activity_arr:    Array like or sparse matrix as the state in hidden layer.
            rnn_activity_arr:       Array like or sparse matrix as the state in RNN.

        Returns:
            Tuple(
                Array like or sparse matrix of reconstructed instances of time-series,
                Array like or sparse matrix of the state in hidden layer,
                Array like or sparse matrix of the state in RNN
            )
        '''
        cdef int sample_n = observed_arr.shape[0]
        cdef int hidden_n

        if hidden_activity_arr is not None:
            self.__encoder.graph.hidden_activity_arr = hidden_activity_arr
        else:
            hidden_n = self.__encoder.graph.weights_lstm_hidden_arr.shape[0]
            self.__encoder.graph.hidden_activity_arr = np.zeros((sample_n, hidden_n), dtype=np.float64)

        if rnn_activity_arr is not None:
            self.__encoder.graph.rnn_activity_arr = rnn_activity_arr
        else:
            hidden_n = self.__encoder.graph.weights_lstm_hidden_arr.shape[0]
            self.__encoder.graph.rnn_activity_arr = np.zeros((sample_n, hidden_n), dtype=np.float64)

        hidden_n = self.__decoder.graph.weights_lstm_hidden_arr.shape[0]
        self.__decoder.graph.hidden_activity_arr = np.zeros((sample_n, hidden_n), dtype=np.float64)
        self.__decoder.graph.rnn_activity_arr = np.zeros((sample_n, hidden_n), dtype=np.float64)

        cdef np.ndarray[DOUBLE_t, ndim=2] encoded_arr = self.__encoder.inference(
            observed_arr
        )
        cdef np.ndarray[DOUBLE_t, ndim=2] decoded_arr = self.__decoder.inference(
            self.__encoder.get_feature_points()[:, ::-1, :]
        )
        cdef np.ndarray[DOUBLE_t, ndim=3] _hidden_activity_arr = self.__decoder.get_feature_points()[:, ::-1, :]

        self.__feature_points_arr = self.__encoder.graph.hidden_activity_arr

        self.__reconstruction_error_arr = self.__computable_loss.compute_loss(
            _hidden_activity_arr[:, 0, :],
            observed_arr[:, 0, :],
            axis=0
        )
        return _hidden_activity_arr

    def get_feature_points(self):
        '''
        Extract the activities in hidden layer and reset it, 
        considering this method will be called per one cycle in instances of time-series.

        Returns:
            The array like or sparse matrix of feature points.
        '''
        cdef np.ndarray[DOUBLE_t, ndim=2] feature_points_arr = self.__feature_points_arr[:, -1, :]
        return feature_points_arr

    def get_reconstruction_error(self):
        '''
        Extract the reconstructed error in inferencing.
        
        Returns:
            The array like or sparse matrix of reconstruction error. 
        '''
        cdef np.ndarray[DOUBLE_t, ndim=1] reconstruction_error_arr = self.__reconstruction_error_arr
        return reconstruction_error_arr

    def set_readonly(self, value):
        ''' setter '''
        raise TypeError("This property must be read-only.")

    def get_encoder(self):
        ''' getter '''
        return self.__encoder

    encoder = property(get_encoder, set_readonly)

    def get_decoder(self):
        ''' getter '''
        return self.__decoder

    decoder = property(get_decoder, set_readonly)

    def get_verificatable_result(self):
        ''' getter '''
        if isinstance(self.__verificatable_result, VerificatableResult):
            return self.__verificatable_result
        else:
            raise TypeError()

    def set_verificatable_result(self, value):
        ''' setter '''
        if isinstance(value, VerificatableResult):
            self.__verificatable_result = value
        else:
            raise TypeError()
    
    verificatable_result = property(get_verificatable_result, set_verificatable_result)
