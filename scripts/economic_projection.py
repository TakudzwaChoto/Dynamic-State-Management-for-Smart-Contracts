#!/usr/bin/env python3
"""Economic Projection - Mainnet cost calculation"""

gas_price_gwei = 80
eth_price_usd = 3000
migrations_per_year = 365
gas_saved_per_migration = 14.2e6 - 0.85e6

annual_gas_saved = migrations_per_year * gas_saved_per_migration
annual_eth_saved = annual_gas_saved * gas_price_gwei * 1e-9
annual_usd_saved = annual_eth_saved * eth_price_usd

print("="*60)
print("MAINNET ECONOMIC PROJECTION")
print("="*60)
print(f"Annual gas saved: {annual_gas_saved:.0f} ({annual_gas_saved/1e9:.2f} billion)")
print(f"Annual ETH saved: {annual_eth_saved:.2f} ETH")
print(f"Annual USD saved: ${annual_usd_saved:,.0f}")
print("="*60)
