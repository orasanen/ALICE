## Debugging

If you are encountering problems with SylNet, please refer to sylnet.log that is automatically
generated to ALICE main folder upon ALICE execution. SylNet error printing to command line is disabled
due to a large number of warnings due to the use of Tensorflow 1.

### Some common problems:

##### Broken env
```bash
Error #1: "CondaValueError: prefix already exists: /<your_condadir>/envs/ALICE" when creating the Conda environment
```

If you have installed an earlier version of ALICE before, please remove the old environment with 

```
  $ rm -rf /<your_condadir>/envs/ALICE/
```

and then install ALICE from scratch.

##### My ALICE installation no longer works on macOS, but worked fine earlier

Re-install ALICE by:
1) deleting the old ALICE conda environment (see above)  
2) pulling the newest version of the ALICE repository, and   
3) creating a new conda environment using the updated installation instructions that use ALICE_macOS.yml as the environment specification file. 
