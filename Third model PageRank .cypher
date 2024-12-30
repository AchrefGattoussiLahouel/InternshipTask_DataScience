CALL gds.graph.project(
  'healthcareGraphPageRank2',
  ['Case', 'Drug', 'Outcome', 'AgeGroup'],  // Define which nodes to include
  ['IS_PRIMARY_SUSPECT', 'HAS_REACTION', 'RESULTED_IN', 'FALLS_UNDER', 'PRESCRIBED', 'IS_CONCOMITANT']
) 


CALL gds.pageRank.stream('healthcareGraphPageRank2', {
  maxIterations: 20,
  dampingFactor: 0.85,
  nodeLabels: ['Case', 'Drug', 'Outcome', 'AgeGroup'],  // Specify the nodes you want to rank
  relationshipTypes: ['IS_PRIMARY_SUSPECT', 'HAS_REACTION', 'RESULTED_IN', 'FALLS_UNDER', 'PRESCRIBED', 'IS_CONCOMITANT']  // Specify the relationships
})
YIELD nodeId, score
MATCH (n) WHERE id(n) = nodeId
WITH n, score, labels(n) AS node_labels
RETURN node_labels AS labels, 
       CASE
         WHEN 'AgeGroup' IN node_labels THEN n.ageGroup
         WHEN 'Drug' IN node_labels THEN n.name
         WHEN 'Outcome' IN node_labels THEN n.outcome
         ELSE 'Unknown'
       END AS node_name,
       score
ORDER BY score DESC
LIMIT 10;