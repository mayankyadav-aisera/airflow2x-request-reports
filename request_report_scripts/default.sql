SELECT *
FROM (
	SELECT
		ai_tickets_view.id AS request_id,
		conversation_requests.request AS request,
		JSON_EXTRACT(conversation_responses.response, '$.answers[*].answerContents[*].data') AS response,
		ai_tickets_view.resolution_status AS resolution_status,
		ai_tickets_view.resolution_detail AS resolution_detail,
		CAST(conversation_details.req_time AS CHAR) AS req_time,
        CAST(conversation_details.resp_time AS CHAR) AS resp_time,
		conversation_details.context_id AS context_id,
		conversation_details.request_id AS conv_request_id,
		conversation_details.response_id AS conv_response_id,
		bots.name AS bot_name
	FROM aisera_{tenant_id}.ai_tickets_view
		INNER JOIN aisera_{tenant_id}.conversation_sessions
			ON ai_tickets_view.session_id = conversation_sessions.id
		INNER JOIN aisera_{tenant_id}.bots
			ON ai_tickets_view.bot_id = bots.id
		LEFT JOIN aisera_{tenant_id}.conversations
			ON ai_tickets_view.conversation_id = conversations.id
    	LEFT JOIN aisera_{tenant_id}.conversation_details
    		ON conversations.id = conversation_details.context_id
    	LEFT JOIN aisera_{tenant_id}.conversation_requests
			ON conversation_details.request_id = conversation_requests.id
		LEFT JOIN aisera_{tenant_id}.conversation_responses
			ON conversation_details.response_id = conversation_responses.id
	WHERE
	 	ai_tickets_view.bot_id IN ({bot_id})
) X
WHERE
    request IS NOT NULL
    AND response is NOT NULL
    AND req_time >= CONCAT('{start_date}', ' 00:00:00')
    AND req_time <= CONCAT('{end_date}', ' 00:00:00')
ORDER BY request_id;