## Summary

Seeded baseline test data across all five tables using real auth.users 
UUIDs. Data supports FK tests, trigger tests, and JOIN queries in later 
issues.

## Row counts

- profiles: 2
- spaces: 3
- plants: 4
- data_logs: 4
- tasks: 3

## Notes

Auth users were inserted directly via SQL into auth.users due to Supabase 
free tier email rate limiting. UUIDs were retrieved and used as FK 
references throughout the seed.

One task (Check pH levels) references the Northern Lights plant 
(bbbbbbbb-0000-0000-0000-000000000003). This plant will be deleted in 
Issue #6 to demonstrate ON DELETE SET NULL behavior. The task should 
survive with plant_id NULL.

## Checklist

- [x] 2 profiles inserted
- [x] 3 spaces inserted
- [x] 4 plants inserted
- [x] 4 data_logs inserted
- [x] 3 tasks inserted
- [x] Row counts verified
- [x] 04_seed.sql committed
- [x] Evidence screenshot committed

Closes #5