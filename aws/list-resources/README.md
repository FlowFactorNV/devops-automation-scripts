# List AWS resources

Simple Python script to list common AWS resources in tables. I use it when looking for resources that can be cleaned
up.

## Usage

Create and activate a virtual environment:

```shell
python -m venv .venv
source .venv/bin/activate
```

Install dependencies (boto3 and tabulate):

```shell
pip install -r requirements.txt
```

Make sure you are authenticated on the AWS CLI (`aws sso login`) and have at least 1 profile configured in `~/.aws/config`.
Then run

```shell
python list_aws_resources.py -v
```
