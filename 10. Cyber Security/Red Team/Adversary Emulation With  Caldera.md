![[Pasted image 20221101231020.png]]
![[Pasted image 20221101232001.png]]

# Prerequisites & Requirements
-   Familiarity with Linux system administration.
-   Familiarity with Windows.
-   Functional knowledge of TCP/IP.
-   Familiarity with penetration testing concepts and life-cycle.

# What is Red Teaming?
- Red Teaming VS Pentesting

![[Pasted image 20221107232250.png]]

# What is adversary emulation?
Adversary emulation is the process of emulating the tactics, techniques, and behavior of a specific adversary.

# Red Team Kill-chain

![[image6.webp]]

1.  Adversary Emulation
2.  Reconnaissance
3.  Gaining access/initial compromise
4.  Privilege escalation
5.  Persistence 
6.  Lateral movement

# MITRE ATT&CK Tactics & Techniques

![[image23.webp]]

# MITRE Caldera
Caldera is a cyber security framework designed to easily automate adversary emulation, assist manual red teams, and automate incident response.

It is built on the MITRE ATT&CK framework and utilizes a client-server system, where the server is used to set up agents(clients) and initiate operations.

The framework consists of two components:
1.  The core system. This is the framework code, consisting of what is available in this repository. Included is an asynchronous command-and-control (C2) server with a REST API and a web interface.
2.  Plugins. These repositories expand the core framework capabilities and provide additional functionality. Examples include agents, reporting, collections of TTPs, and more.

- Caldera GitHub repository: [https://github.com/mitre/caldera](https://github.com/mitre/caldera)
- Caldera Documentation: [https://caldera.readthedocs.io/en/latest/](https://caldera.readthedocs.io/en/latest/)



# Reference
- [Red Team Adversary Emulation With Caldera - YouTube](https://www.youtube.com/watch?v=EIHLXWnK1Dw&list=PLBf0hzazHTGMjSlPmJ73Cydh9vCqxukCu&index=1)
- [Welcome to CALDERA’s documentation! — caldera documentation](https://caldera.readthedocs.io/en/latest/index.html)
- [mitre/caldera: Automated Adversary Emulation Platform (github.com)](https://github.com/mitre/caldera)

