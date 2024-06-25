from aisera_bol_common import *

from airflow.operators.python import ShortCircuitOperator
from airflow.operators.dummy import DummyOperator
from airflow.operators.python import BranchPythonOperator
import airflow
from airflow import DAG
from datetime import timedelta

# ######### Platform template ##########
# donot modify this block
SCHEDULE = "16 18 * * *"  # AISERA_SCHEDULE
TENANT_ID = "10000"
# ######### Platform template ##########

################### Airflow DAG
default_args = {
    'owner': 'aisera',
    'depends_on_past': False,
    'email': ['airflow@aisera.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': TASK_RETRIES,
    'retry_delay': timedelta(minutes=TASK_RETRY_DELAY),
    'schedule_interval': None
}

with DAG(
        'aisera_request_export_{}'.format(TENANT_ID),
        default_args=default_args,
        description='aisera request export',
        max_active_runs=1,
        start_date=airflow.utils.dates.days_ago(10),
        catchup=False,
        schedule_interval=SCHEDULE,
        tags=['2022-Jan']
) as dag:
    ###################  Common TASK
    start_pipeline = ShortCircuitOperator(task_id='start_pipeline',
                                          python_callable=run_aisera_request_export_task,
                                          op_args=[TENANT_ID],
                                          trigger_rule='one_success',
                                          dag=dag)