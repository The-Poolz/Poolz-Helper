module.exports = {
  istanbulReporter: ['text', 'text-summary', 'json', 'html', 'lcov'],
  configureYulOptimizer: true,
  solcOptimizerDetails: {
    peephole: false,
    jumpdestRemover: false,
    orderLiterals: true,
    deduplicate: false,
    cse: false,
    constantOptimizer: false,
    yul: true,
  },
};
