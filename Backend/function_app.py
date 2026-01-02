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
        # Try to fetch the entity
        try:
            entity = table_client.get_entity(partition_key="visitor_stats", row_key="1")
            entity['count'] += 1
            table_client.update_entity(entity)
        except ResourceNotFoundError:
            # If it doesn't exist, create it with a count of 1
            entity = {
                'PartitionKey': 'visitor_stats',
                'RowKey': '1',
                'count': 1
            }
            table_client.create_entity(entity)
        
        new_count = entity['count']
        
        return func.HttpResponse(
            body=json.dumps({"count": new_count}),
            mimetype="application/json",
            status_code=200
        )

    except Exception as e:
        # Fallback error handling
        return func.HttpResponse(json.dumps({"error": str(e)}), mimetype="application/json", status_code=500)