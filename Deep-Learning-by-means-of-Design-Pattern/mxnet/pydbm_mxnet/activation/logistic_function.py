# -*- coding: utf-8 -*-
import mxnet as mx
from pydbm_mxnet.activation.interface.activating_function_interface import ActivatingFunctionInterface


class LogisticFunction(ActivatingFunctionInterface):
    '''
    Logistic Function.
    '''

    def activate(self, x):
        '''
        Return of result from this activation function.

        Args:
            x   Parameter.

        Returns:
            The result.
        '''
        return 1.0 / (1.0 + mx.ndarray.exp(-x))

    def derivative(self, y):
        '''
        Derivative.

        Args:
            y:  Parameter.
        Returns:
            The result.
        '''
        return self.activate(y) * (1 - self.activate(y))
