import azure.functions as func
import json
import os
from azure.data.tables import TableClient

app = func.FunctionApp()

@app.route(route="GetVisitorCount", auth_level=func.AuthLevel.ANONYMOUS)
def GetVisitorCount(req: func.HttpRequest) -> func.HttpResponse:
    # 1. Use the name we defined in Terraform
    conn_str = os.environ.get("TABLE_STORAGE_CONNECTION_STRING")
    
    # 2. Match the table name from Terraform
    table_client = TableClient.from_connection_string(conn_str, table_name="VisitorCount")

    try:
        # 3. Fetch the entity
        entity = table_client.get_entity(partition_key="visitor_stats", row_key="1")
        
        # 4. Increment
        entity['count'] = entity['count'] + 1
        
        # 5. Update
        table_client.update_entity(entity)
        new_count = entity['count']
        
    except Exception as e:
        # If the row doesn't exist yet, we can't increment it!
        return func.HttpResponse(f"Error: {str(e)}", status_code=500)

    return func.HttpResponse(
        body=json.dumps({"count": new_count}),
        mimetype="application/json",
        status_code=200
    )