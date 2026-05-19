import numpy as np
import pandas as pd
import os

np.random.seed(42)

def generate_water_quality_data(n_samples):
    ph = np.clip(np.random.normal(7.5, 1.0, n_samples), 0, 14)
    turbidity = np.clip(np.random.exponential(scale=50, size=n_samples), 0, 5000)
    dissolved_oxygen = np.clip(np.random.normal(8, 2, n_samples), 0, 20)
    temperature = np.clip(np.random.normal(20, 10, n_samples), 0, 50)
    contaminants = np.random.choice([0, 1], size=n_samples, p=[0.95, 0.05])
    
    return df

train_df = generate_water_quality_data(20000)
print(f"Generated 20,000 training records at data/training_data.csv")
