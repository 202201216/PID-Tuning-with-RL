# TD3-RL Agent for Nonlinear Mass-Spring-Damper System
Youtube Video: [Link](https://youtu.be/M37ucY0VHSE).

This project uses reinforcement learning (RL) to tune PID controllers for a nonlinear mass-spring-damper system. It applies the TD3 algorithm to compare the performance of a traditional PID tuner with an RL-trained PID tuner, evaluated through simulations with step and constant inputs.

## Overview
This project demonstrates the application of reinforcement learning (RL), specifically the Twin Delayed Deep Deterministic Policy Gradient (TD3) algorithm, to tune PID controllers for a nonlinear mass-spring-damper system. The research paper **"Tuning PID Controllers Using Reinforcement Learning (RL) for Nonlinear Systems Control"** served as the foundation for this project.

The aim is to compare the performance of:
1. A conventional PID tuner.
2. A trained TD3-RL agent applied as a PID tuner.

The performance is assessed using simulations with step and constant inputs applied to the nonlinear mass-spring-damper system.

---

## Motivation
I became interested in this project because of my curiosity about machine learning and how it can be used in real-life applications. While learning about reinforcement learning (RL), I wanted to see how these techniques work in MATLAB and Simulink. **The Reinforcement Learning Onramp** course in MATLAB gave me a good introduction to RL and motivated me to apply it to a real-world control system. This project gave me a hands-on chance to combine what I know about control systems with RL, and I ended up using RL to create a PID tuner.

---
## Structure of the Project

### Files and Resources

1. **Research Paper**:  
   - *Tuning PID Controllers Using Reinforcement Learning (RL) for Nonlinear Systems Control* (provided as [PID with RL Research Paper PDF](PDFs/PID_RL.pdf)).  
   - Key insights from the paper guided the architecture of the RL environment and the training of the TD3 agent.  
2. **Simulink Models**:  
   - Mass-spring-damper system implemented as a nonlinear system.  
   - Reward and observation subsystems designed according to the research guidelines.  
3. **Simscape Model**:  
   - A detailed physical model of the mass-spring-damper system created using Simscape components, including:  
     - **Wall and Base**: Representing the fixed boundary conditions of the system.  
     - **Prismatic Joint**: Capturing the linear motion, combined with spring and damper elements.  
     - **Mass**: Representing the movable object in the system.  
     - **Position Sensor**: Monitoring the mass's displacement, with a **PS-Simulink Converter** to enable integration with Simulink-based RL training and simulation workflows.  
4. [**Scripts**](MATALB/Matlab_Script.m)
5. [**Graphs**](PDFs/Simulation_Graphs.pdf)
---

## Methodology
### 1. Problem Description
The control of a mass-spring-damper system presents challenges due to its nonlinear nature. A PID controller requires careful tuning of its parameters (P, I, D) to achieve stable and desired system performance. The research paper proposes using reinforcement learning to dynamically adjust these parameters.

### 2. System Details
- **Nonlinear System**: A mass-spring-damper system with the equation of motion:
  $$ m\ddot{x} + b\dot{x} + kx = F $$
  where:
  - \(m\): Mass.
  - \(b\): Damping coefficient.
  - \(k\): Spring constant.
  - \(F\): External force (control input).
- **Observation Block**: Provides PID outputs [P, I, D].
- **Reward Block**: Penalizes deviation from the target while encouraging stability around the setpoint. For detailed description for [Reward Block PDF](PDFs/Reward_Block_Description.pdf) used.

### 3. Training the TD3-RL Agent
- **RL Environment**:
  - The agent observes the PID parameters and the system state.
  - Actions represent force adjustments.
  - Rewards are designed to incentivize reaching and maintaining the target setpoint with minimal overshoot or oscillation.
- **Hyperparameters**:
  - Mini-batch size: 128
  - Experience buffer: 500,000
  - Gaussian noise: Standard deviation = 0.3, Decay rate = 1e-5

---

## Results
1. **Conventional PID Tuning (Figure 1)**:
   - The system exhibits stable behavior but lacks adaptive capabilities for varying dynamics.
   - P: 1.519185 , I: 1.017997 , D: 0.561749
   - [!PID Tunner](Images/PID_Tunner.png)
2. **TD3-RL Agent Tuning (Figure 2 & 3)**:
   - Initial simulations show promising results with constant inputs.
   - Further training and parameter adjustments improve performance.
   - P: 0.02318 , I: 1.562 , D: -0.001193
   - [!First Trail](Images/First_trail_RL.png)
   - P: 0.04963 , I: 1.763 , D: -0.0001421
   - [!Second Trail](Images/Second_trail_RL_1.png)
3. **Step Input with TD3-RL Agent (Figure 4)**:
   - The agent successfully tracks step changes, minimizing overshoot and achieving stability efficiently.
   - P: 0.04941 , I: 1.842 , D: -0.0001415
   - [!Second Trail with Step input](Images/Second_trail_RL_Step.png)

---

## Insights and Relevance
This project integrates concepts from control systems and reinforcement learning to explore innovative methods for nonlinear system control. The TD3-RL agent:
- Learns and adapts PID parameters dynamically.
- Outperforms conventional tuning methods in dynamic environments.
- Demonstrates the effectiveness of RL-based control strategies for complex, nonlinear systems.

The study aligns with topics covered in control systems and autonomous systems courses, including:
- Nonlinear dynamics.
- PID controller design and tuning.
- Reinforcement learning for control applications.

---

## Conclusion
This project illustrates the feasibility and advantages of using reinforcement learning to tune PID controllers for nonlinear systems. The TD3 algorithm provides a robust framework for learning and adapting control parameters, achieving superior performance compared to conventional methods.

For further details, refer to:
- **Research Paper**: [`PID_RL.pdf`](PDFs/PID_RL.pdf)
- **Simulation Results**: [`Graphs.pdf`](PDFs/Simulation_Graphs.pdf)
- **Simscape Model**: [Youtube Link](https://www.youtube.com/watch?v=Z7hcMVJNbTg) and [Matlab Model](https://in.mathworks.com/matlabcentral/fileexchange/98689-modeling-and-simulation-of-spring-mass-damper-system-smd)

---

### How to Run the Project without pretrained Agent

---

1. **Prerequisites**:
   - Ensure you have **MATLAB** installed with the following toolboxes:
     - Reinforcement Learning Toolbox
     - Simulink
     - Deep Learning Toolbox
   - Verify that your working directory contains only the following files:
     - **MATLAB script** (e.g., `Matlab_Script.m`)
     - **Simulink model** (e.g., `Simulink_Mass_Spring_Damper_RL.slx`)

2. **Running the Project**:
   - Open **MATLAB** and set the working directory to the folder containing the required files.
   - Run the MATLAB script by typing the following in the command window:
     ```matlab
     run('Matlab_Script.m')
     ```
   - The script will automatically:
     - Load the Simulink model (`Simscape_Simulink_Mass_Spring_Damper_RL.slx`).
     - Train the reinforcement learning agent (TD3 algorithm) within the Simulink model environment.

3. **Training Process**:
   - The training process involves running simulations of the mass-spring-damper system, during which the RL agent learns to tune the control parameters dynamically.
   - The training progress can be monitored through the **"training-progress"** window, which displays the reward trends and convergence metrics.

4. **Using the Tuned Agent**:
   - After training completes, the RL agent can be used for control purposes directly in the Simulink model.
   - You do not need any other files; the trained agent is embedded within the Simulink model for use.

---
### How to Run the Project with pretrained Agent
---
- Open **MATLAB** and set the working directory to the folder containing the required files.
- Run the MATLAB script by typing the following in the command window:
   ```matlab
   run('Run_Pretrained_Agent.m')
   ```
- The script will automatically:
   - Load the Simulink model (`Simscape_Simulink_Mass_Spring_Damper_RL.slx`).
   - Use trained the reinforcement learning agent (TD3 algorithm) within the Simulink model environment.

---

This workflow eliminates the need for additional files or manual configurations, ensuring a straightforward and efficient execution process.
