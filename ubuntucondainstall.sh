rm -rf $HOME/miniconda ~/miniconda.sh
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p $HOME/miniconda
rm -rf ~/miniconda.sh
source $HOME/miniconda/bin/activate
conda init bash
conda config --set auto_activate_base false
conda update -n base -c defaults conda -y
conda update --all -y
