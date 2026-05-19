#!/usr/bin/env python3
"""Gas Benchmark - 50-run statistical analysis"""
import subprocess, json, statistics, time, re, os
from datetime import datetime
import numpy as np
from scipy import stats

NUM_RUNS = 50
CONTRACTS = ["OptimizedPattern", "BaselineArray"]

def run_forge_test(contract_name):
    try:
        result = subprocess.run(["forge", "test", "--match-contract", contract_name, "--gas-report"], capture_output=True, text=True, timeout=60)
        for line in result.stdout.split("\n"):
            if "deployment" in line.lower() or "Deployment" in line:
                numbers = re.findall(r"\d+", line)
                if numbers: return int(numbers[-1])
        return None
    except: return None

def main():
    print("="*60)
    print(f"Gas Benchmark - {NUM_RUNS} runs")
    results = {c: [] for c in CONTRACTS}
    for run in range(NUM_RUNS):
        print(f"  Run {run+1}/{NUM_RUNS}")
        for contract in CONTRACTS:
            gas = run_forge_test(contract)
            if gas: results[contract].append(gas)
        time.sleep(0.5)
    
    opt_data = results["OptimizedPattern"]
    base_data = results["BaselineArray"]
    if opt_data and base_data:
        opt_mean = statistics.mean(opt_data)
        base_mean = statistics.mean(base_data)
        reduction = (base_mean - opt_mean) / base_mean * 100
        print(f"\nOptimized: {opt_mean:.0f} gas")
        print(f"Baseline: {base_mean:.0f} gas")
        print(f"Reduction: {reduction:.1f}%")
        os.makedirs("results", exist_ok=True)
        with open("results/gas_results.json", "w") as f:
            json.dump({"optimized_mean": opt_mean, "baseline_mean": base_mean, "reduction_percent": reduction}, f, indent=2)

if __name__ == "__main__":
    main()
