# Reinforcement Learning Library: pyqlearning

`pyqlearning` is Python library to implement Reinforcement Learning, especially for Q-Learning which can be optimized by Annealing models such as Simulated Annealing, Adaptive Simulated Annealing, and Quantum Monte Carlo Method.

## Installation

Install using pip:

```sh
pip install pyqlearning
```

### Source code

The source code is currently hosted on GitHub.

- [accel-brain-code/Reinforcement-Learning](https://github.com/chimera0/accel-brain-code/tree/master/Reinforcement-Learning)

### Python package index(PyPI)

Installers for the latest released version are available at the Python package index.

- [pyqlearning : Python Package Index](https://pypi.python.org/pypi/pyqlearning/)

### Dependencies

- numpy: v1.13.3 or higher.
- pandas: v0.22.0 or higher.

## Documentation

Full documentation is available on [https://code.accel-brain.com/Reinforcement-Learning/](https://code.accel-brain.com/Reinforcement-Learning/) . This document contains information on functionally reusability, functional scalability and functional extensibility.

## Description

According to the Reinforcement Learning problem settings, Q-Learning is a kind of **Temporal Difference learning(TD Learning)** that can be considered as hybrid of **Monte Carlo** method and **Dynamic Programming** method. As Monte Carlo method, TD Learning algorithm can learn by experience without model of environment. And this learning algorithm is functional extension of bootstrap method as Dynamic Programming Method.

In this library, Q-Learning can be distinguished into **Epsilon Greedy Q-Leanring** and **Boltzmann Q-Learning**. These algorithm is 
functionally equivalent but their structures should be conceptually distinguished.

Epsilon Greedy Q-Leanring algorithm is a typical off-policy algorithm. In this paradigm, *stochastic* searching and *deterministic* searching can coexist by hyperparameter <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/epsilon.gif" /> that is probability that agent searches greedy. Greedy searching is *deterministic* in the sense that policy of agent follows the selection that maximizes the Q-Value.

Boltzmann Q-Learning algorithm is based on Boltzmann action selection mechanism, where the probability
<img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/x_i.gif" /> of selecting the action <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/i.gif" /> is given by

<!-- $$x_i(t) = \frac{e^{\frac{Q_i(t)}{T}}}{\sum_{k}^{ } e^{\frac{Q_i(t)}{T}}} \ \  (i = 1, 2, ..., n)$$ -->
<div><img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/boltzmann_action_selection.gif" /></div>

where the temperature <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/t_gt_0.gif" /> controls exploration/exploitation tradeoff. For <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/t_to_0.gif" /> the agent always acts greedily and chooses the strategy corresponding to the maximum Q–value, so as to be pure *deterministic* exploitation, whereas for <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/t_to_infty.gif" /> the agent’s strategy is completely random, so as to be pure *stochastic* exploration.

Considering many variable parts and functional extensions in the Q-learning paradigm from perspective of *commonality/variability analysis* in order to practice object-oriented design, this library provides abstract class that defines the skeleton of a Q-Learning algorithm in an operation, deferring some steps in concrete variant algorithms such as Epsilon Greedy Q-Leanring and Boltzmann Q-Learning to client subclasses. The abstract class in this library lets subclasses redefine certain steps of a Q-Learning algorithm without changing the algorithm's structure.

## Tutorial: Simple Maze Solving by Q-Learning (Jupyter notebook)

[search_maze_by_q_learning.ipynb](https://github.com/chimera0/accel-brain-code/blob/master/Reinforcement-Learning/search_maze_by_q_learning.ipynb) is a Jupyter notebook which demonstrates a simple maze solving algorithm based on Epsilon-Greedy Q-Learning or Q-Learning, loosely coupled with Deep Boltzmann Machine(DBM).

In this demonstration, let me cite the Q-Learning, *loosely coupled with Deep Boltzmann Machine* (DBM). As API Documentation of [pydbm](https://github.com/chimera0/accel-brain-code/tree/master/Deep-Learning-by-means-of-Design-Pattern) library has pointed out, DBM is functionally equivalent to stacked auto-encoder. The main function I observe is the same as dimensions reduction(or pre-training). Then the function of this DBM is dimensionality reduction of reward value matrix.

Q-Learning, loosely coupled with Deep Boltzmann Machine (DBM), is a more effective way to solve maze. The pre-training by DBM allow Q-Learning agent to abstract feature of reward value matrix and to observe the map in a bird's-eye view. Then agent can reach the goal with a smaller number of trials.

As shown in the below image, the state-action value function and parameters setting can be designed to correspond with the optimality of route.

<div align="center">
 <table style="border: none;">
  <tr>
   <td width="45%" align="center">
    <a href="https://github.com/chimera0/accel-brain-code/blob/master/Reinforcement-Learning/search_maze_by_q_learning.ipynb" target="_top"><img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/maze_map.png" /></a>
    <p>Maze map</p>
   </td>
   <td width="45%" align="center">
    <a href="https://github.com/chimera0/accel-brain-code/blob/master/Reinforcement-Learning/search_maze_by_q_learning.ipynb" target="_top"><img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/feature_point.png" /></a>
    <p>Feature Points in the maze map</p>
   </td>
  </tr>
  <tr>
   <td width="45%" align="center">
    <a href="https://github.com/chimera0/accel-brain-code/blob/master/Reinforcement-Learning/search_maze_by_q_learning.ipynb" target="_top"><img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/fail_searched.png" /></a>
    <p>The result of searching by Epsilon-Greedy Q-Learning</p>
   </td>
   <td width="45%" align="center">
    <a href="https://github.com/chimera0/accel-brain-code/blob/master/Reinforcement-Learning/search_maze_by_q_learning.ipynb" target="_top"><img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/maze_q_learning_result.png"  /></a>
    <p>The result of searching by Q-Learning, loosely coupled with Deep Boltzmann Machine.</p>
   </td>
  </tr>
 </table>
</div>

## Tutorial: Complexity of Hyperparameters, or how can be hyperparameters decided?

There are many hyperparameters that we have to set before the actual searching and learning process begins. Each parameter should be decided in relation to Reinforcement Learning theory and it cause side effects in training model. Because of this complexity of hyperparameters, so-called the hyperparameter tuning must become a burden of Data scientists and R & D engineers from the perspective of not only a theoretical point of view but also implementation level.

### Combinatorial optimization problem and Simulated Annealing.

This issue can be considered as **Combinatorial optimization problem** which is an optimization problem, where an optimal solution has to be identified from a finite set of solutions. The solutions are normally discrete or can be converted into discrete. This is an important topic studied in operations research such as software engineering, artificial intelligence(AI), and machine learning. For instance, travelling sales man problem is one of the popular combinatorial optimization problem.

In this problem setting, this library provides an Annealing Model to search optimal combination of hyperparameters. For instance, **Simulated Annealing** is a probabilistic single solution based search method inspired by the annealing process in metallurgy. Annealing is a physical process referred to as tempering certain alloys of metal, glass, or crystal by heating above its melting point, holding its temperature, and then cooling it very slowly until it solidifies into a perfect crystalline structure. The simulation of this process is known as simulated annealing.

### Functional comparison.

[annealing_hand_written_digits.ipynb](https://github.com/chimera0/accel-brain-code/blob/master/Reinforcement-Learning/annealing_hand_written_digits.ipynb) is a Jupyter notebook which demonstrates a very simple classification problem: Recognizing hand-written digits, in which the aim is to assign each input vector to one of a finite number of discrete categories, to learn observed data points from already labeled data how to predict the class of unlabeled data. In the usecase of hand-written digits dataset, the task is to predict, given an image, which digit it represents.

There are many structural extensions and functional equivalents of **Simulated Annealing**. For instance, **Adaptive Simulated Annealing**, also known as the very fast simulated reannealing, is a very efficient version of simulated annealing. And **Quantum Monte Carlo**, which is generally known a stochastic method to solve the Schrödinger equation, is one of the earliest types of solution in order to simulate the **Quantum Annealing** in classical computer. In summary, one of the function of this algorithm is to solve the ground state search problem which is known as logically equivalent to combinatorial optimization problem. Then this Jupyter notebook demonstrates functional comparison in the same problem setting.

## Demonstration: Epsilon Greedy Q-Learning and Simulated Annealing.

Import python modules.

```python
from pyqlearning.annealingmodel.costfunctionable.greedy_q_learning_cost import GreedyQLearningCost
from pyqlearning.annealingmodel.simulated_annealing import SimulatedAnnealing
from devsample.maze_greedy_q_learning import MazeGreedyQLearning
```

The class `GreedyQLearningCost` is implemented the interface `CostFunctionable` to be called by `AnnealingModel`. This cost function is defined by

<div><img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/q_cost.gif"></div>

where <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/n_search.gif"> is the number of searching(learning) and L is a limit of <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/n_search.gif">. 

Like Monte Carlo method, let us draw random samples from a normal (Gaussian) or unifrom distribution.

```python
# Epsilon-Greedy rate in Epsilon-Greedy-Q-Learning.
greedy_rate_arr = np.random.normal(loc=0.5, scale=0.1, size=100)
# Alpha value in Q-Learning.
alpha_value_arr = np.random.normal(loc=0.5, scale=0.1, size=100)
# Gamma value in Q-Learning.
gamma_value_arr = np.random.normal(loc=0.5, scale=0.1, size=100)
# Limit of the number of Learning(searching).
limit_arr = np.random.normal(loc=10, scale=1, size=100)

var_arr = np.c_[greedy_rate_arr, alpha_value_arr, gamma_value_arr, limit_arr]
```

Instantiate and initialize `MazeGreedyQLearning` which is-a `GreedyQLearning`.

```python
# Instantiation.
greedy_q_learning = MazeGreedyQLearning()
greedy_q_learning.initialize(hoge=fuga)
```

Instantiate `GreedyQLearningCost` which is implemented the interface `CostFunctionable` to be called by `AnnealingModel`.

```python
init_state_key = ("Some", "data")
cost_functionable = GreedyQLearningCost(
    greedy_q_learning, 
    init_state_key=init_state_key
)
```

Instantiate `SimulatedAnnealing` which is-a `AnnealingModel`.

```python
annealing_model = SimulatedAnnealing(
    # is-a `CostFunctionable`.
    cost_functionable=cost_functionable,
    # The number of annealing cycles.
    cycles_num=5,
    # The number of trials of searching per a cycle.
    trials_per_cycle=3
)
```

Fit the `var_arr` to `annealing_model`.

```python
annealing_model.var_arr = var_arr
```

Start annealing.

```python
annealing_model.annealing()
```

To extract result of searching, call the property `predicted_log_list` which is list of tuple: `(Cost, Delta energy, Mean of delta energy, probability in Boltzmann distribution, accept flag)`. And refer the property `x` which is `np.ndarray` that has combination of hyperparameters. The optimal combination can be extracted as follow.

```python
# Extract list: [(Cost, Delta energy, Mean of delta energy, probability, accept)]
predicted_log_arr = annealing_model.predicted_log_arr

# [greedy rate, Alpha value, Gamma value, Limit of the number of searching.]
min_e_v_arr = annealing_model.var_arr[np.argmin(predicted_log_arr[:, 2])]
```

### Contingency of definitions

The above definition of cost function is possible option: not necessity but contingent from the point of view of modal logic. You should questions the necessity of definition and re-define, for designing the implementation of interface `CostFunctionable`, in relation to *your* problem settings.

## Demonstration: Epsilon Greedy Q-Learning and Adaptive Simulated Annealing.

There are various Simulated Annealing such as Boltzmann Annealing, Adaptive Simulated Annealing(SAS), and Quantum Simulated Annealing. On the premise of Combinatorial optimization problem, these annealing methods can be considered as functionally equivalent. The *Commonality/Variability* in these methods are able to keep responsibility of objects all straight as the class diagram below indicates.

<img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/class_diagram_annealing_model.png" />

### Code sample.

`AdaptiveSimulatedAnnealing` is-a subclass of `SimulatedAnnealing`. The *variability* is aggregated in the method `AdaptiveSimulatedAnnealing.adaptive_set()` which must be called before executing `AdaptiveSimulatedAnnealing.annealing()`.

```python
from pyqlearning.annealingmodel.simulatedannealing.adaptive_simulated_annealing import AdaptiveSimulatedAnnealing

annealing_model = AdaptiveSimulatedAnnealing(
    cost_functionable=cost_functionable,
    cycles_num=33,
    trials_per_cycle=3,
    accepted_sol_num=0.0,
    init_prob=0.7,
    final_prob=0.001,
    start_pos=0,
    move_range=3
)

# Variability part.
annealing_model.adaptive_set(
    # How often will this model reanneals there per cycles.
    reannealing_per=50,
    # Thermostat.
    thermostat=0.,
    # The minimum temperature.
    t_min=0.001,
    # The default temperature.
    t_default=1.0
)
annealing_model.var_arr = params_arr
annealing_model.annealing()
```

To extract result of searching, call the property like the case of using `SimulatedAnnealing`. If you want to know how to visualize the searching process, see my Jupyter notebook: [annealing_hand_written_digits.ipynb](https://github.com/chimera0/accel-brain-code/blob/master/Reinforcement-Learning/annealing_hand_written_digits.ipynb).

## Demonstration: Epsilon Greedy Q-Learning and Quantum Monte Carlo.

Generally, Quantum Monte Carlo is a stochastic method to solve the Schrödinger equation. This algorithm is one of the earliest types of solution in order to simulate the Quantum Annealing in classical computer. In summary, one of the function of this algorithm is to solve the ground state search problem which is known as logically equivalent to combinatorial optimization problem.

According to theory of spin glasses, the ground state search problem can be described as minimization energy determined by the hamiltonian <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/h_0.png" /> as follow

<img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/hamiltonian_in_ising_model.png" />

where <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/pauli_z_i.png" /> refers to the Pauli spin matrix below for the spin-half particle at lattice point <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/i.gif" />. In spin glasses, random value is assigned to <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/j_i_j.png" />. The number of combinations is enormous. If this value is <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/n.png" />, a trial frequency is <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/2_n.png" />. This computation complexity makes it impossible to solve the ground state search problem. Then, in theory of spin glasses, the standard hamiltonian is re-described in expanded form.

<img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/hamiltonian_in_t_ising_model.png" />

where <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/pauli_x_i.png" /> also refers to the Pauli spin matrix and <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/gamma.png" /> is so-called annealing coefficient, which is hyperparameter that contains vely high value. Ising model to follow this Hamiltonian is known as the Transverse Ising model.

In relation to this system, thermal equilibrium amount of a physical quantity <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/q.png?1" /> is as follow.

<img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/langle_q_rangle.png" />

If <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/h.png" /> is a diagonal matrix, then also <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/e_beta_h.png" /> is diagonal matrix. If diagonal element in <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/h.png" /> is <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/e_i.png" />, Each diagonal element is <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/e_beta_h_ij_e_i.png" />. However if <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/h.png" /> has off-diagonal elements, It is known that <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/e_beta_h_ij_e_i_neq.png" /> since for any of the exponent <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/i.gif" /> we must exponentiate the matrix as follow.

<img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/e_matrix_infty.png" />

Therefore, a path integration based on Trotter-Suzuki decomposition has been introduced in Quantum Monte Carlo Method. This path integration makes it possible to obtain the partition function <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/z.png" />.

<img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/z_in_t_ising_model.png" />

where if <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/m.png" /> is large enough, relational expression below is established.

<img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/exp_left_frac_1_m_beta_h_right.png" /></td></tr>

Then the partition function <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/z.png" /> can be re-descibed as follow.

<img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/z_in_t_ising_model_re_described.png" />

where <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/mid_sigma_k_rangle.png" /> is <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/l.png" /> topological products (product spaces). Because <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/h_0.png" /> is the diagonal matrix, <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/tilde_sigma_j_z_mid_sigma.png" />.

Therefore, 

<img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/langle_sigma_k_mid.png" />

The partition function <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/z.png" /> can be re-descibed as follow.

<img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/z_in_t_ising_model_re_described_last.png" />

where <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/m.png" /> is the number of trotter.

This relational expression indicates that the quantum - mechanical Hamiltonian in <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/d.png" /> dimentional Tranverse Ising model is functional equivalence to classical Hamiltonian in <img src="https://storage.googleapis.com/accel-brain-code/Reinforcement-Learning/img/latex/d_1.png" /> dimentional Ising model, which means that the state of the quantum - mechanical system can be approximate by the state of classical system.

### Code sample.

```python
from pyqlearning.annealingmodel.quantum_monte_carlo import QuantumMonteCarlo
from pyqlearning.annealingmodel.distancecomputable.cost_as_distance import CostAsDistance

# User defined function which is-a `CostFuntionable`.
cost_functionable = YourCostFunctions()

# Compute cost as distance for `QuantumMonteCarlo`.
distance_computable = CostAsDistance(params_arr, cost_functionable)

# Init.
annealing_model = QuantumMonteCarlo(
    distance_computable=distance_computable,

    # The number of annealing cycles.
    cycles_num=100,

    # Inverse temperature (Beta).
    inverse_temperature_beta=0.1,

    # Gamma. (so-called annealing coefficient.) 
    gammma=1.0,

    # Attenuation rate for simulated time.
    fractional_reduction=0.99,

    # The dimention of Trotter.
    trotter_dimention=10,

    # The number of Monte Carlo steps.
    mc_step=100,

    # The number of parameters which can be optimized.
    point_num=100,

    # Default `np.ndarray` of 2-D spin glass in Ising model.
    spin_arr=None,

    # Tolerance for the optimization.
    # When the ΔE is not improving by at least `tolerance_diff_e`
    # for two consecutive iterations, annealing will stops.
    tolerance_diff_e=0.01
)

# Execute annealing.
annealing_model.annealing()
```

To extract result of searching, call the property like the case of using `SimulatedAnnealing`. If you want to know how to visualize the searching process, see my Jupyter notebook: [annealing_hand_written_digits.ipynb](https://github.com/chimera0/accel-brain-code/blob/master/Reinforcement-Learning/annealing_hand_written_digits.ipynb).

## Performance Experiment: Q-Learning VS Q-Learning, loosely coupled with Deep Boltzmann Machine.

The tutorial in [search_maze_by_q_learning.ipynb](https://github.com/chimera0/accel-brain-code/blob/master/Reinforcement-Learning/search_maze_by_q_learning.ipynb) exemplifies the function of Deep Boltzmann Machine(DBM). Here, I verify if that DBM impacts on the number of searches by Q-Learning in the maze problem setting.

### Batch program for Q-Learning.

[demo_maze_greedy_q_learning.py](https://github.com/chimera0/accel-brain-code/blob/master/Reinforcement-Learning/demo_maze_greedy_q_learning.py) is a simple maze solving algorithm. `MazeGreedyQLearning` in  [devsample/maze_greedy_q_learning.py](https://github.com/chimera0/accel-brain-code/blob/master/Reinforcement-Learning/devsample/maze_greedy_q_learning.py) is a `Concrete Class` in `Template Method Pattern` to run the Q-Learning algorithm for this task. `GreedyQLearning` in [pyqlearning/qlearning/greedy_q_learning.py](https://github.com/chimera0/accel-brain-code/blob/master/Reinforcement-Learning/pyqlearning/qlearning/greedy_q_learning.py) is also `Concreat Class` for the epsilon-greedy-method. The `Abstract Class` that defines the skeleton of Q-Learning algorithm in the operation and declares algorithm placeholders is [pyqlearning/q_learning.py](https://github.com/chimera0/accel-brain-code/blob/master/Reinforcement-Learning/pyqlearning/q_learning.py).  So [demo_maze_greedy_q_learning.py](https://github.com/chimera0/accel-brain-code/blob/master/Reinforcement-Learning/demo_maze_greedy_q_learning.py) is a kind of `Client` in `Template Method Pattern`. 

This algorithm allow the *agent* to search the goal in maze by *reward value* in each point in map. 

The following is an example of map.

```
[['#' '#' '#' '#' '#' '#' '#' '#' '#' '#']
 ['#' 'S'  4   8   8   4   9   6   0  '#']
 ['#'  2  26   2   5   9   0   6   6  '#']
 ['#'  2  '@' 38   5   8   8   1   2  '#']
 ['#'  3   6   0  49   8   3   4   9  '#']
 ['#'  9   7   4   6  55   7   0   3  '#']
 ['#'  1   8   4   8   2  69   8   2  '#']
 ['#'  1   0   2   1   7   0  76   2  '#']
 ['#'  2   8   0   1   4   7   5  'G' '#']
 ['#' '#' '#' '#' '#' '#' '#' '#' '#' '#']]
```

- `#` is wall in maze.
- `S` is a start point.
- `G` is a goal.
- `@` is the agent.

In relation to reinforcement learning theory, the *state* of *agent* is 2D position coordinates and the *action* is to dicide the direction of movement. Within the wall, the *agent* is movable in a cross direction and can advance by one point at a time. After moving into a new position, the *agent* can obtain a *reward*. On greedy searching, this extrinsically motivated agent performs in order to obtain some *reward* as high as possible. Each *reward value* is plot in map.

To see how *agent* can search and rearch the goal, run the batch program: [demo_maze_greedy_q_learning.py](https://github.com/chimera0/accel-brain-code/blob/master/Reinforcement-Learning/demo_maze_greedy_q_learning.py)

```bash
python demo_maze_greedy_q_learning.py
```

### Batch program for Q-Learning, loosely coupled with Deep Boltzmann Machine.

[demo_maze_deep_boltzmann_q_learning.py](https://github.com/chimera0/accel-brain-code/blob/master/Reinforcement-Learning/demo_maze_deep_boltzmann_q_learning.py) is a demonstration of how the *Q-Learning* can be to *deepen*. A so-called *Deep Q-Network* (DQN) is meant only as an example. In this demonstration, let me cite the *Q-Learning* , loosely coupled with **Deep Boltzmann Machine** (DBM). As API Documentation of [pydbm](https://github.com/chimera0/accel-brain-code/tree/master/Deep-Learning-by-means-of-Design-Pattern) library has pointed out, DBM is functionally equivalent to stacked auto-encoder. The main function I observe is the same as dimensions reduction(or pre-training). Then the function this DBM is dimensionality reduction of *reward value* matrix.

Q-Learning, loosely coupled with Deep Boltzmann Machine (DBM), is a more effective way to solve maze. The pre-training by DBM allow Q-Learning *agent* to abstract feature of `reward value` matrix and to observe the map in a bird's-eye view. Then *agent* can reache the goal with a smaller number of trials.

To realize the power of DBM, I performed a simple experiment.

### Feature engineering

For instance, a feature in each coordinate can be transformed and extracted by reward value as so-called *observed data points* in its adjoining points. More formally, see [search_maze_by_q_learning.ipynb](https://github.com/chimera0/accel-brain-code/blob/master/Reinforcement-Learning/search_maze_by_q_learning.ipynb).

Then the feature representation can be as calculated. After this pre-training, the DBM has extracted *feature points* below.

```
[['#' '#' '#' '#' '#' '#' '#' '#' '#' '#']
 ['#' 'S' 0.22186305563593528 0.22170599483791015 0.2216928599218454
  0.22164807496640074 0.22170371283788584 0.22164021608623224
  0.2218165339471332 '#']
 ['#' 0.22174745260072407 0.221880094307873 0.22174244728061343
  0.2214709292493749 0.22174626768015263 0.2216756589222596
  0.22181057818975275 0.22174525714311788 '#']
 ['#' 0.22177496678085065 0.2219122743656551 0.22187543599733664
  0.22170745588799798 0.2215226084843615 0.22153827385193636
  0.22168466277729898 0.22179391402965035 '#']
 ['#' 0.2215341770250964 0.22174315536140118 0.22143149966676515
  0.22181685688674144 0.22178215385805333 0.2212249704384472
  0.22149210148879617 0.22185413678274837 '#']
 ['#' 0.22162363223483128 0.22171313373253035 0.2217109987501002
  0.22152432841656014 0.22175562457887335 0.22176040052504634
  0.22137688854285298 0.22175365642579478 '#']
 ['#' 0.22149515807715153 0.22169199881701832 0.22169558478042856
  0.2216904005450013 0.22145368271014734 0.2217144069625017
  0.2214896100292738 0.221398594191006 '#']
 ['#' 0.22139837944992058 0.22130176116356184 0.2215414328019404
  0.22146667964656613 0.22164354506366127 0.22148685616333666
  0.22162822887193126 0.22140174437162474 '#']
 ['#' 0.22140060918518528 0.22155145714201702 0.22162929776464463
  0.22147466752374162 0.22150300682310872 0.22162775291471243
  0.2214233075299188 'G' '#']
 ['#' '#' '#' '#' '#' '#' '#' '#' '#' '#']]
```

To see how *agent* can search and rearch the goal, install [pydbm](https://github.com/chimera0/accel-brain-code/tree/master/Deep-Learning-by-means-of-Design-Pattern) library and run the batch program: [demo_maze_deep_boltzmann_q_learning.py](https://github.com/chimera0/accel-brain-code/blob/master/Reinforcement-Learning/demo_maze_deep_boltzmann_q_learning.py)

```bash
python demo_maze_deep_boltzmann_q_learning.py
```

### Case 1: for more greedy searches

#### Map setting.
- map size: `20` * `20`.
- Start Point: (1, 1)
- End Point: (18, 18)

#### Reward value

```python
import numpy as np

map_d = 20
map_arr = np.random.rand(map_d, map_d)
map_arr += np.diag(list(range(map_d)))
```

#### Hyperparameters

- Alpha: `0.9`
- Gamma: `0.9`
- Greedy rate(epsilon): `0.75`
    * More Greedy.

#### Searching plan

- number of trials: `1000`
- Maximum Number of searches: `10000`

#### Metrics (Number of searches)

Tests show that the number of searches on the *Q-Learning* with pre-training is smaller than not with pre-training.

<table>
<thead>
<tr>
<th align="left">Number of searches</th>
<th align="left">not pre-training</th>
<th align="left">pre-training</th>
</tr>
</thead>
<tbody>
<tr>
<td align="left">Max</td>
<td align="left">8155</td>
<td align="left">4373</td>
</tr>
<tr>
<td align="left">mean</td>
<td align="left">3753.80</td>
<td align="left">1826.0</td>
</tr>
<tr>
<td align="left">median</td>
<td align="left">3142.0</td>
<td align="left">1192.0</td>
</tr>
<tr>
<td align="left">min</td>
<td align="left">1791</td>
<td align="left">229</td>
</tr>
<tr>
<td align="left">var</td>
<td align="left">3262099.36</td>
<td align="left">2342445.78</td>
</tr>
<tr>
<td align="left">std</td>
<td align="left">1806.13</td>
<td align="left">1530.56</td>
</tr></tbody></table>

### Case 2: for less greedy searches

#### Map setting
- map size: `20` * `20`.
- Start Point: (1, 1)
- End Point: (18, 18)

#### Reward value

```python
import numpy as np

map_d = 20
map_arr = np.random.rand(map_d, map_d)
map_arr += np.diag(list(range(map_d)))
```

#### Hyperparameters

- Alpha: `0.9`
- Gamma: `0.9`
- Greedy rate(epsilon): `0.25`
    * Less Greedy.

#### Searching plan

- number of trials: `1000`
- Maximum Number of searches: `10000`

#### Metrics (Number of searches)

<table>
<thead>
<tr>
<th align="left">Number of searches</th>
<th align="left">not pre-training</th>
<th align="left">pre-training</th>
</tr>
</thead>
<tbody>
<tr>
<td align="left">Max</td>
<td align="left">10000</td>
<td align="left">10000</td>
</tr>
<tr>
<td align="left">mean</td>
<td align="left">7136.0</td>
<td align="left">3296.89</td>
</tr>
<tr>
<td align="left">median</td>
<td align="left">9305.0</td>
<td align="left">1765.0</td>
</tr>
<tr>
<td align="left">min</td>
<td align="left">2401</td>
<td align="left">195</td>
</tr>
<tr>
<td align="left">var</td>
<td align="left">9734021.11</td>
<td align="left">10270136.10</td>
</tr>
<tr>
<td align="left">std</td>
<td align="left">3119.94</td>
<td align="left">3204.71</td>
</tr></tbody></table>

Under the assumption that the less number of searches the better, *Q-Learning*, loosely coupled with *Deep Boltzmann Machine*, is a more effective way to solve maze in not greedy mode as well as greedy mode.

## References

### Q-Learning models.

- Agrawal, S., & Goyal, N. (2011). Analysis of Thompson sampling for the multi-armed bandit problem. arXiv preprint arXiv:1111.1797.
- Bubeck, S., & Cesa-Bianchi, N. (2012). Regret analysis of stochastic and nonstochastic multi-armed bandit problems. arXiv preprint arXiv:1204.5721.
- Chapelle, O., & Li, L. (2011). An empirical evaluation of thompson sampling. In Advances in neural information processing systems (pp. 2249-2257).
- Du, K. L., & Swamy, M. N. S. (2016). Search and optimization by metaheuristics (p. 434). New York City: Springer.
- Kaufmann, E., Cappe, O., & Garivier, A. (2012). On Bayesian upper confidence bounds for bandit problems. In International Conference on Artificial Intelligence and Statistics (pp. 592-600).
- Mnih, V., Kavukcuoglu, K., Silver, D., Graves, A., Antonoglou, I., Wierstra, D., & Riedmiller, M. (2013). Playing atari with deep reinforcement learning. arXiv preprint arXiv:1312.5602.
- Richard Sutton and Andrew Barto (1998). Reinforcement Learning. MIT Press.
- Watkins, C. J. C. H. (1989). Learning from delayed rewards (Doctoral dissertation, University of Cambridge).
- Watkins, C. J., & Dayan, P. (1992). Q-learning. Machine learning, 8(3-4), 279-292.
- White, J. (2012). Bandit algorithms for website optimization. ” O’Reilly Media, Inc.”.

### Annealing models.

- Bektas, T. (2006). The multiple traveling salesman problem: an overview of formulations and solution procedures. Omega, 34(3), 209-219.
- Bertsimas, D., & Tsitsiklis, J. (1993). Simulated annealing. Statistical science, 8(1), 10-15.
- Das, A., & Chakrabarti, B. K. (Eds.). (2005). Quantum annealing and related optimization methods (Vol. 679). Springer Science & Business Media.
- Du, K. L., & Swamy, M. N. S. (2016). Search and optimization by metaheuristics. New York City: Springer.
- Edwards, S. F., & Anderson, P. W. (1975). Theory of spin glasses. Journal of Physics F: Metal Physics, 5(5), 965.
- Facchi, P., & Pascazio, S. (2008). Quantum Zeno dynamics: mathematical and physical aspects. Journal of Physics A: Mathematical and Theoretical, 41(49), 493001.
- Heim, B., Rønnow, T. F., Isakov, S. V., & Troyer, M. (2015). Quantum versus classical annealing of Ising spin glasses. Science, 348(6231), 215-217.
- Heisenberg, W. (1925) Über quantentheoretische Umdeutung kinematischer und mechanischer Beziehungen. Z. Phys. 33, pp.879—893.
- Heisenberg, W. (1927). Über den anschaulichen Inhalt der quantentheoretischen Kinematik und Mechanik. Zeitschrift fur Physik, 43, 172-198.
- Heisenberg, W. (1984). The development of quantum mechanics. In Scientific Review Papers, Talks, and Books -Wissenschaftliche Übersichtsartikel, Vorträge und Bücher (pp. 226-237). Springer Berlin Heidelberg.
Hilgevoord, Jan and Uffink, Jos, "The Uncertainty Principle", The Stanford Encyclopedia of Philosophy (Winter 2016 Edition), Edward N. Zalta (ed.), URL = ＜https://plato.stanford.edu/archives/win2016/entries/qt-uncertainty/＞.
- Jarzynski, C. (1997). Nonequilibrium equality for free energy differences. Physical Review Letters, 78(14), 2690.
- Messiah, A. (1966). Quantum mechanics. 2 (1966). North-Holland Publishing Company.
- Mezard, M., & Montanari, A. (2009). Information, physics, and computation. Oxford University Press.
- Nallusamy, R., Duraiswamy, K., Dhanalaksmi, R., & Parthiban, P. (2009). Optimization of non-linear multiple traveling salesman problem using k-means clustering, shrink wrap algorithm and meta-heuristics. International Journal of Nonlinear Science, 8(4), 480-487.
- Schrödinger, E. (1926). Quantisierung als eigenwertproblem. Annalen der physik, 385(13), S.437-490.
- Somma, R. D., Batista, C. D., & Ortiz, G. (2007). Quantum approach to classical statistical mechanics. Physical review letters, 99(3), 030603.
- 鈴木正. (2008). 「組み合わせ最適化問題と量子アニーリング: 量子断熱発展の理論と性能評価」.,『物性研究』, 90(4): pp598-676. 参照箇所はpp619-624.
- 西森秀稔、大関真之(2018) 『量子アニーリングの基礎』須藤 彰三、岡 真 監修、共立出版、参照箇所はpp9-46.

### More detail demos

- [Webクローラ型人工知能：キメラ・ネットワークの仕様](https://media.accel-brain.com/_chimera-network-is-web-crawling-ai/)
    - 20001 bots are running as 20001 web-crawlers and 20001 web-scrapers.

### Related PoC

- [量子力学、統計力学、熱力学における天才物理学者たちの神学的な形象について](https://accel-brain.com/das-theologische-bild-genialer-physiker-in-der-quantenmechanik-und-der-statistischen-mechanik-und-thermodynamik/) (Japanese)
    - [プロトタイプの開発：アニーリング](https://accel-brain.com/das-theologische-bild-genialer-physiker-in-der-quantenmechanik-und-der-statistischen-mechanik-und-thermodynamik/2/#i-12)
- [Webクローラ型人工知能によるパラドックス探索暴露機能の社会進化論](https://accel-brain.com/social-evolution-of-exploration-and-exposure-of-paradox-by-web-crawling-type-artificial-intelligence/) (Japanese)
    - [プロトタイプの開発：人工知能エージェント「キメラ・ネットワーク」](https://accel-brain.com/social-evolution-of-exploration-and-exposure-of-paradox-by-web-crawling-type-artificial-intelligence/5/#i-8)
- [深層強化学習のベイズ主義的な情報探索に駆動された自然言語処理の意味論](https://accel-brain.com/semantics-of-natural-language-processing-driven-by-bayesian-information-search-by-deep-reinforcement-learning/) (Japanese)
    - [プロトタイプの開発：深層学習と強化学習による「排除された第三項」の推論](https://accel-brain.com/semantics-of-natural-language-processing-driven-by-bayesian-information-search-by-deep-reinforcement-learning/4/#i-5)
- [ハッカー倫理に準拠した人工知能のアーキテクチャ設計](https://accel-brain.com/architectural-design-of-artificial-intelligence-conforming-to-hacker-ethics/) (Japanese)
    - [プロトタイプの開発：深層強化学習のアーキテクチャ設計](https://accel-brain.com/architectural-design-of-artificial-intelligence-conforming-to-hacker-ethics/5/#i-2)    
- [ヴァーチャルリアリティにおける動物的「身体」の物神崇拝的なユースケース](https://accel-brain.com/cyborg-fetischismus-in-sammlung-von-animalisch-korper-in-virtual-reality/) (Japanese)
    - [プロトタイプの開発：「人工天使ヒューズ＝ヒストリア」](https://accel-brain.com/cyborg-fetischismus-in-sammlung-von-animalisch-korper-in-virtual-reality/4/#i-6)

## Author

- chimera0(RUM)

## Author URI

- http://accel-brain.com/

## License

- GNU General Public License v2.0
