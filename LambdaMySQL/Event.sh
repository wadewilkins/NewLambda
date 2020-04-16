

aws events put-rule \
--name MyScheduledRule \
--schedule-expression 'rate(5 minutes)'
