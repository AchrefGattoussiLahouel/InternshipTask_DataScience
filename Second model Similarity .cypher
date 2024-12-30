CALL gds.graph.project(
  'healthcareGraph', 
  ['Case', 'Drug', 'Outcome'],
  ['IS_PRIMARY_SUSPECT', 'RESULTED_IN']
);


CALL gds.nodeSimilarity.stream('caseSimilarityGraph')
YIELD node1, node2, similarity
RETURN gds.util.asNode(node1).name AS Case1,
       gds.util.asNode(node2).name AS Case2,
       similarity
ORDER BY similarity DESC
LIMIT 10;


CALL gds.nodeSimilarity.stream('healthcareGraph', {
  nodeLabels: ['Case'],
  relationshipTypes: ['IS_PRIMARY_SUSPECT', 'RESULTED_IN'],
  similarityMetric: 'JACCARD'
})
YIELD node1, node2, similarity
RETURN gds.util.asNode(node1).id AS case1_id, 
       gds.util.asNode(node2).id AS case2_id, 
       similarity
ORDER BY similarity DESC
LIMIT 10;