### sudo apt-get install ttf-mscorefonts-installer error

E: Unable to locate package ttf-mscorefont-installer

Enable multiverse

Command Line Way of enabling Ubuntu software Repositories For 12.10 and above:
To enable main repository,
sudo add-apt-repository main
To enable universe repository,
sudo add-apt-repository universe
To enable multiverse repository,
sudo add-apt-repository multiverse
To enable restricted repository,
sudo add-apt-repository restricted
NOTE:

After enabling the repositories, don't forget to update it.Run the below command to update the repositories,

sudo apt-get update
