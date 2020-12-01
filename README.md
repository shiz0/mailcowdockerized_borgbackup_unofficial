<br />
<p align="center">
  <a href="https://github.com/shiz0/mailcowdockerized_borgbackup_unofficial/">
    <img src="images/logo.png" alt="Logo" width="256" height="256">
  </a>

  <h2 align="center">BorgBackup solution for mailcow</h3>

  <p align="center">
    Backup your <a href="https://mailcow.email/"><strong>mailcow-dockerized</strong></a> with <a href="https://www.borgbackup.org/"><strong>borg</strong></a>
    <br />
  </p>
</p>
<br />

<!-- ABOUT THE PROJECT -->
# About The Project

This project is intended to provide an easy way to add a backup solution with Borg to an existing Mailcow installation. This backup solution backs up the data of the mailcow to a configurable Borg repository server with a configurable interval and number of backup versions.

<br />

<!-- GETTING STARTED -->
# Getting Started
The installation guide assumes in this case that a working mailcow-dockerized stack is installed and a Hetzner StorageBox is used as backup target.

## Preparation
* Create the required directories and files:
  ```
  $ mkdir -p /opt/backup/mailcow/secrets
  $ touch /opt/backup/mailcow/secrets/borg_repo_pw
  ```
* Create an SSH key for authentication to the Borg repository using `ssh-keygen -t ed25519 -a 100` and save it as `/opt/backup/mailcow/secrets/id_rsa`:
  ```
  $ ssh-keygen -t ed25519 -a 100
  Generating public/private ed25519 key pair.
  Enter file in which to save the key (/root/.ssh/id_ed25519): /opt/backup/mailcow/secrets/id_rsa
  Enter passphrase (empty for no passphrase): 
  Enter same passphrase again: 
  Your identification has been saved in /opt/backup/mailcow/secrets/id_rsa
  Your public key has been saved in /opt/backup/mailcow/secrets/id_rsa.pub
  The key fingerprint is:
  SHA256:Ic8ENYMDEFWwv1o4Hs8sKu00eUUkq/Qqa+PfiJot7uY root@mailcowhost
  The key's randomart image is:
  +--[ED25519 256]--+
  |  o+=++o+        |
  |     =o. o       |
  |  . o o.o        |
  | . o o = .       |
  |  . . o S        |
  |   o o .         |
  |..= = o          |
  |oXo++O           |
  |%E*+oo+          |
  +----[SHA256]-----+
  ```
* Creating a backup directory on the StorageBox and setting up a user:
  * Connect to a SFTP/SCP client via the address and port 23 on the StorageBox and create a new directory. Give the directory the permission '0700'. Example: `BorgBackups/mailcow`
  * Create a subdirectory (`BorgBackups/mailcow/.ssh`) and in it a file named `authorized_keys` and assign permission `0600` to this file
  * Add to the file `authorized_keys` on your StorageBox the content of the file `/opt/backup/mailcow/secrets/id_rsa.pub`
  * Create a new sub-account in Hetzner's robot interface at your StorageBox and assign the directory `BorgBackups/mailcow` to it.
  <br/>Important: The StorageBox requires SSH access and if the mailcow is outside of the Hetzner network, external access must also be allowed/activated.
* Set the password for the Borg repository:
  ```
  $ echo "your super secure password" > /opt/backup/mailcow/secrets/borg_repo_pw
  ```

<br/>

## Installation

1. Copy the contents of the `docker-compose.override.yml.example` in your mailcow directory into the file `docker-compose.override.yml`

2. Open the `docker-compose.override.yml` file with an editor of your choice and adjust the following lines according to your desired configuration:
    ```
    - BORG_REPO=ssh://uXXXXXX-subX@uXXXXXX.your-storagebox.de:23/./backup
    - BACKUP_INTERVAL=hourly
    ```
    Replace the corresponding usernames in the URL of `BORG_REPO` and adjust the value of `BACKUP_INTERVAL` to your desired interval. Possible values are `5min`, `15min`, `hourly`, `daily`, `weekly`, `monthly` or `custom`. If you choose the value `custom` you also have to copy the file `crontab` from this repository to `/opt/backup/mailcow` and adjust it to your needs. Afterwards you add a link to the `crontab` file in the `docker-compose.override.yml`:
    ```
    borgbackup_unofficial-mailcow:
      volumes:
        ...
        - /opt/backup/mailcow/crontab:/root/crontab
    ```

3. Start the backup container:
    ```
    $ cd /opt/mailcow-dockerized/ && docker-compose up -d
    ```

<br />

For possible values/usage of BORG_REPO, BORG_RSH, BORG_PASSPHRASE, the BORG_*_CMD variables, as well as other borg commands, please consult the borg documentat
ion at \
https://borgbackup.readthedocs.io/

<br />

And, last but not least: \
**Always check your logs, attempt restores etc. to be sure it's working!**

<br />

## Roadmap

See the [open issues](https://github.com/shiz0/mailcowdockerized_borgbackup_unofficial/issues) for a list of proposed features (and known issues).

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<!-- LICENSE -->
## License

Distributed under the GPL-3.0 License. See `LICENSE` for more information.