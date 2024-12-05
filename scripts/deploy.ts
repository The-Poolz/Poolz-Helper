import { GAS_LIMIT } from './constants';
import { ethers } from 'hardhat';

export const deployed = async <T>(contractName: string, ...args: string[]): Promise<T> => {
  const Contract = await ethers.getContractFactory(contractName);
  return Contract.deploy(...args, { gasLimit: GAS_LIMIT }) as Promise<T>;
};
