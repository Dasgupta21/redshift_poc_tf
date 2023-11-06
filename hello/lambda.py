import json
import psycopg2
import os

def lambda_handler(event, context):
    print("event collected is {}".format(event))
    for record in event['Records'] :
        s3_bucket = record['s3']['bucket']['name']
        print("Bucket name is {}".format(s3_bucket))
        s3_key = record['s3']['object']['key']
        print("Bucket key name is {}".format(s3_key))
        from_path = "s3://{}/{}".format(s3_bucket, s3_key)
        print("from path {}".format(from_path))
        Access_key = os.getenv('AWS_Access_key')
        Access_Secret = os.getenv('AWS_Access_Secret')
        dbname = os.getenv('dbname')
        endpoint = os.getenv('host')
        user = os.getenv('user')
        password = os.getenv('password')
        tablename = os.getenv('tablename')
        redshift_schema = os.getenv('schemaname')
        
        # Find the index of .com
        index_com = endpoint.find(".com")
        
        if index_com != -1:
            # Extract the substring up to .com
            host_name = endpoint[:index_com + 4]  # Adding 4 to include ".com"
            print(host_name)
        else:
            print("host string NOT FOUND")
        
        connection = psycopg2.connect(dbname = dbname,
                                       host = host_name,
                                       port = '5439',
                                       user = user,
                                       password = password)
                                       
        print('after connection....')
        curs = connection.cursor()
        print('after cursor....')
        querry = "COPY {}.{} FROM '{}' CREDENTIALS 'aws_access_key_id={};aws_secret_access_key={}' CSV;".format(redshift_schema,tablename,from_path,Access_key,Access_Secret)
        print("query is {}".format(querry))
        print('after querry....')
        curs.execute(querry)
        connection.commit()
        #print(curs.fetchmany(3))
        print('after execute....')
        curs.close()
        print('after curs close....')
        connection.close()
        print('after connection close....')
        print('executed....')