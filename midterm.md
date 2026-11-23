
=========================================================================================================================================================


1. What is this repository?
    This repository is designed to represent the student's understanding of key concepts covered thus far (up to Nov 20th, 2026) and includes concepts
covered throughout the semester such as the fundamentals of advanced security mechanisms and procedures with Windows and Linux systems along with
Docker containers that was covered within in-class & independent labs, in-class lectures and powerpoint presentations.

    The skills demonstrated here showcase the student is able to conduct basic hardening activities upon Linux systems through the use of strategic 
user creation & group assignment, disabling unnecessary services, and conducting hardening practices upon authentication with PAM and hardened sshd
files; all of which is enumerated in a verbose lynis auditing summary.

    Similar skills were expressed upon Windows systems where the student was capable of using administrative Powershell rights to verify Windows
Defender is enabled, how to enumerate firewall statuses, validation that insecure services are interrupted and disabled, installation and use
of Sysmon with SwiftOnSecurity to tabulate security events, etc.

    Docker containers were also shown to be created in a multi-staged structure with pins and prevent the container from being executed as a root user.
There are also additional provisions generated from commands targeted to invoke security modules such as --read-only access rights in conjunction with
a seccomp profile that restricts unneeded system calls to our python application.

    A series of third-party auditing tools were also used upon our hardened docker container to find any vulnerabilities or CVEs that have the chance
to be leveraged by a threat actor. The student was responsible for recording and evaluating one of many CVEs that would populate from these tools and
then compared with existing frameworks such as the NIST's NVD and MITRE | ATT&K. The student was also responsible for creating a YAML file which 
contained and would trigger one of the events discovered within their CVE analysis

    Finally, the student had used dependency pinning and evaluation with all of the resources they used previously and created a temporary PR which would
downgrade flask and showcasing the dangers of downgrading applications to known vulnerable versions.


=========================================================================================================================================================


2. Cross-platform hardening comparison & evaluation:

|-----------------------------|--------------------------------------|-------------------------------------|------------------------------------------|
|        Control Area:        |                 Linux:               |              Windows:               |                  Docker:                 |
|-----------------------------|--------------------------------------|-------------------------------------|------------------------------------------|
|      **Kernel Model**       | Organized as a kernel that supports  | Utilizes the Windows NT kernel with | Is built off your existing host system   |
|                             | full user-space in isolated          | kernel/user space seperation.       | and containers share the kernel of your  |
|                             | instances to minimize direct user    |                                     | host, but with isolated user-space with  |
|                             | interaction.                         |                                     | namespaces/cgroups.                      |
|-----------------------------|--------------------------------------|-------------------------------------|------------------------------------------|
|                             | Uses discrestionary access control   | Uses Group Policy and Group Policy  | Uses seccomp profiles for filtering      |
|     **Access Control**      | in categories known as "owner",      | Objects in conjunction with domain  | container calls to reduce direct kernel  |
|                             | "group", and "other" and may be      | controllers and Kerberos to manage  | interaction along Linux capabilities to  |
|                             | manually configured via chmod binary | user access rights. Scales well     | break root-access into granular units    |
|                             | for read, write and execute perms.   | in enterprise environments and mid- | with PoLP enforcement. Shares Linux      |
|                             | May also use SUID and GUID binaries  | sized organizations.                | AppArmor and SELiinux for additional     |
|                             | alongside sudo & sudoers.            |                                     | Mandatory Access Control enforcement.    |
|-----------------------------|--------------------------------------|-------------------------------------|------------------------------------------|
|                             | Syslog, auth.log and kern.log are    | Event log can relay discovered      | Use Trivy or Snyk to monitor the CI/CD   |
|    **Auditing / Logging**   | invaluble for logging and auiting    | system events such as login prompts,| pipeline for any CVEs. Docker scans all  |
|                             | and stored within "/var/logs". These | object access/manipulation, and     | images before they reach and be accepted |
|                             | logs provide event reconstruction to | policy modifications. Application   | in a registry; desireable for supply     |
|                             | investigators to accurately rebuild  | of CIS/STIG guideline standards on  | chain security standards. This is shares |
|                             | an incident or compromise for acute  | all systems for a uniform,          | Linux APT package management to detect   |
|                             | analysis.                            | centralized auditing baseline.      | supply chain risks to validate packages. |
|-----------------------------|--------------------------------------|-------------------------------------|------------------------------------------|
|  **Hardening and Security** | Minimize installed packages to       | Disabling legacy protocols such as  | Docker shares Linux imaging systems to   |
|                             | to reduce the threat threshold of    | SMBv1 to prevent historical or      | install secure, trusted baseline images  |
|                             | CVEs upon the system. Actively use   | similar attacks upon Windows is     | that are distroless to manually config   |
|                             | ufw for packet filtering. Use SSH    | required. And restricting local     | each layer securely. Minimal packages    |
|                             | hardening to restrict unwanted IP    | admin accounts reduce the risk of   | are also heavily encouraged to reduce    |
|                             | access from accessing the root user. |                                     | threats from unnecessary packages.       |
|-----------------------------|--------------------------------------|-------------------------------------|------------------------------------------|
|  **Common Attack Surface**  | Abuse of improper SUID/GUID configs  | NTFS ADSes are a legacy feature for | Structured off Linux where misconfigured |
|                             | would allow attackers to gain higher | Windows systems that still exist    | or default docker.sock inside a container|
|                             | system permissions in escalation     | and are used by attackers to hide   | would grant root access to a container or|
|                             | attacks.                             | information and malware scripts.    | even potential container escape on your  |
|                             |                                      |                                     | host OS.                                 |
|-----------------------------|--------------------------------------|-------------------------------------|------------------------------------------|

One hardening step per platform that I would suggest for each platform includes the following:

Linux: 
    Limiting package installations are a fundamental principle that any Linux user should inherit as every package runs the possibility of
installing features, scripts, or other unnecessary components which may hamper traditional system operations, but may also present a higher attack
probability. Treat every package entering your system as opening a door or window, opening a few might be fine, but installing every package known
to man is like breaking down an entire wall that just opening a small window and could lead to a compromise due to various CVEs which may exist on
some packages. (Ref: Week 3, slide 11.)

Windows:
    Disabling unnecessary SMBv1 & other legacy protocols are a paramount change that all Windows systems should enforce due to it having a
long, extensive history with several threat actor campaigns such as WannaCry or NotPetya incidents. All Windows systems have this service enabled by
default, but for some additional support, Network Administrators should also actively log SMB and other depreciated legacy ports and protocols to
minimize the attack window upon internal systems. (Ref: Week 3, slide 16.)

Docker:
    Utilize known-good or fresh base images for installing a docker upon your system. Similar to .iso file, docker files can be customized with
packages, configurations or additional options; however, doing so from a clean instance is much safer due to the issues prompted within the Linux
area of this report. Having unknown or random packages may present future risks to your system. Also, since docker behaves as an extension that
shares your system's resources directly with the kernel (unlike a VM) this presents additional risks upon your own system if configured improperly
or if necessary packages or configurations are missing. Docker is an extremely valuable utility, but it should be treated as an extension to your
main system that presents an entirely new boundary for risks. (Ref: Week 3, slide 21.)


========================================================================================================================================================


3. Supply-chain threat modeling

_____________________________________________________________________________________________________________________________________________________|
|                                       |                                                                      |                                     |
|                                       |                                                                      |                                     |
|          Threats:                     |                                Remediations/Controls:                |           References:               |
|                                       |                                                                      |                                     |
|----------------------------------------------------------------------------------------------------------------------------------------------------|
|                                       |                                                                      |                                     |
|   Exploitation of CVEs                |                      Trivy, Syft & Grype reports showcasing          |   Week 4 slides, slides 6, 18 & 10  |
|   (CVE-2026-76642; T1068)             |                      vulnerable packages and system heuristics       |   "System Administration & Policy   |
|                                       |                      which may be exploited with support from CVES.  |   for Docker, Windows & Linux"      |
|                                       |                      Basic patch management and incorporate SELinux  |                                     |
|                                       |                      and/or AppArmor to remediate in the future.     |                                     |
|                                       |                                                                      |                                     |
|----------------------------------------------------------------------------------------------------------------------------------------------------|
|                                       |                                                                      |                                     |
|  Execution of malicious PS scripts    |                      Enable Windows to detect and flag 4104 events   |   Week 5 slides, slide 9            |
|                                       |                      to actively monitor unauthorized scripts from   |   "Security Analysis & Threat       |
|                                       |                      being executed upon a system. Doing so will     |   Intelligence."                    |
|                                       |                      improve log trails in the event of IR to see    |                                     |
|                                       |                      what may have caused a security event or be     |                                     |
|                                       |                      able to squash a severe incident before it      |                                     |
|                                       |                      initiates.                                      |                                     |
|                                       |                                                                      |                                     |
|----------------------------------------------------------------------------------------------------------------------------------------------------|
|                                       |                                                                      |                                     |
|                                       |                                                                      |                                     |
| Abusing Insecure Dependencies         |                    Using dependency management & secure workflow     |   Week 8 slides, slides 9-11        |
|                                       |                     platforms for all third-party dependancies       |  "Dependency Management & Version   |
|                                       |                     as insecure versions of third-party resources    |  Control for Github."               |
|                                       |                     may be exploited by vulnerabilities. This goes   |                                     |
|                                       |                    for other components such as applications too.    |                                     |
|                                       |                                                                      |                                     |
|----------------------------------------------------------------------------------------------------------------------------------------------------|
|                                       |                                                                      |                                     |
| Permissive Docker Containers          |                   Strict enforcement over a docker instance via      |    Week 6 Slides, slides 13-15      |
|                                       |                   multi-staged build orders, base image digest       |  "Docker Containers &               |
|                                       |                   pins, containers stripped of root access,          |   Virtualization."                  |
|                                       |                   denying the ability for rights management,         |                                     |
|                                       |                   allowing only mandatory system call helps a        |                                     |
|                                       |                   container have PoLP.                               |                                     |
|                                       |                                                                      |                                     |
|                                       |                                                                      |                                     |
|----------------------------------------------------------------------------------------------------------------------------------------------------|
|                                       |                                                                      |                                     |
| Attempting to Attack Linux            |                PAM is strictly enforced upon the Linux               |  Week 7 slides, slide 24            |
| System Authentication                 |                 client and enforces basic controls such              |  "Enterprise Policy Management"     |
|                                       |                  as having set password requirements and a           |                                     |
|                                       |                   structure to prevent brute-force attempts          |                                     |
|                                       |                    with faillock and maximum attempts.               |                                     |
|                                       |                                                                      |                                     |
|                                       |                                                                      |                                     |
|----------------------------------------------------------------------------------------------------------------------------------------------------|

========================================================================================================================================================


4. Which section proves which learning objective(s)

Section 1 - Linux Host Hardening + Lynis:

- "Implementing Windows and Linux best practices to support against Supply Chain Attacks."


Section 2 - Windows Baseline + Event Log Analysis:

- "Utilize Supply Chain Security Techniques across Windows, Linux and Docker container environments."


Section 3 - Docker Hardened Build + Runtime Controls:

- "Apply enterprise patch and policy management for Docker Containers, including container hardening."


Section 4 - Trivy, Synk & Grype Scan Reports:

- "Understand and integrate Software Bill of Materials (SBOM) into Docker Container workflows."


Section 5 - Policy Enforcement (Docker Bench + Sigma Rule):

- "Apply enterprise patch and policy management for Docker COntainers, including container hardening."


Section 6 - Dependency Pinning, Dependabot & Dependabot Review Gate:

- "Preform Vulnerability Management: scan, patch and restest continuously using CI/CD techniques in GitHub."

- "Applying Dependancy Pinning, Version Control, and Hashing to reduce surprise supply-chain attacks."

- "Configure and manage third-party security scanners within a GitHub CI/CD pipeline."
