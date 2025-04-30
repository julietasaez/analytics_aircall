# analytics_aircall

This dbt project models and analyzes call data for the RS team (Referentes Sociales), using raw data extracted from Aircall and stored in Snowflake.

## Objective

To build a daily performance table by agent with key metrics such as:

- Total number of calls
- Number of inbound and outbound calls
- Average call duration
- Success rate (calls lasting 180 seconds or more)
- Target completion (whether the agent met the 17 outbound calls per day goal)

## Project Structure

- `stg_*`: staging models, used to clean and rename raw data.
- `final_aircall_*`: final models per entity (calls, numbers, users).
- `final_aircall_performance_rs`: final table with daily performance metrics per agent.

## Tools used

- dbt Cloud
- Snowflake (as the data warehouse)
- GitHub for version control
