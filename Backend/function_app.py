import azure.functions as func
import json
import os
from azure.data.tables import TableClient
from azure.core.exceptions import ResourceNotFoundError

app = func.FunctionApp()

@app.route(route="GetVisitorCount", auth_level=func.AuthLevel.ANONYMOUS)
def GetVisitorCount(req: func.HttpRequest) -> func.HttpResponse:
    conn_str = os.environ.get("TABLE_STORAGE_CONNECTION_STRING")
    table_client = TableClient.from_connection_string(conn_str, table_name="VisitorCount")

    try:
        try:
            # 1. Fetch the entity
            entity = table_client.get_entity(partition_key="visitor_stats", row_key="1")
            
            # 2. FIX: Convert the existing value to an integer before adding
            # This handles the "0" string created by Terraform
            current_count = int(entity.get('count', 0))
            entity['count'] = current_count + 1
            
            # 3. Update the table
            table_client.update_entity(entity)
            
        except ResourceNotFoundError:
            # If Terraform didn't create the row for some reason, create it now
            entity = {
                'PartitionKey': 'visitor_stats',
                'RowKey': '1',
                'count': 1
            }
            table_client.create_entity(entity)
        
        # 4. Return the new count
        new_count = entity['count']
        return func.HttpResponse(
            body=json.dumps({"count": new_count}),
            mimetype="application/json",
            status_code=200
        )

    except Exception as e:
        # This will now return a clean JSON error if something else fails
        return func.HttpResponse(
            body=json.dumps({"error": str(e)}), 
            mimetype="application/json", 
            status_code=500
        )