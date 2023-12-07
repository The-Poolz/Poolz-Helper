import { GAS_LIMIT } from './constants';
import { ethers } from 'hardhat';

export const deployed = async <T>(contractName: string, ...args: string[]): Promise<T> => {
  const Contract = await ethers.getContractFactory(contractName);
  const contract = await Contract.deploy(...args, { gasLimit: GAS_LIMIT });
  return contract.deployed() as Promise<T>;
};
