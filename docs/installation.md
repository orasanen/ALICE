## Requirements

ALICE has been developed and so-far tested for a range of Linux and macOS environments. Windows users may encounter problems with some package versions, and we are currently looking into this.

Packages:

- Conda (https://docs.conda.io/en/latest/)
- CMake (```pip install cmake``` or ```conda install cmake```)

(other packages are automatically installed by conda environment)



# Installation 

- Clone the repository with submodules :

```bash
git clone --recurse-submodules https://github.com/orasanen/ALICE/
```

- Make sure you have Conda and Cmake installed.

- Create the conda environment installing all the dependencies :

```bash
cd ALICE
conda env create -f ALICE.yml
```

