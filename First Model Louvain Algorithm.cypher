CALL gds.graph.project(
  'myGraph',
  ['Case', 'Drug', 'Reaction', 'Outcome'],  
  {
    IS_PRIMARY_SUSPECT: {
      type: 'IS_PRIMARY_SUSPECT',
      orientation: 'UNDIRECTED'
    },
    HAS_REACTION: {
      type: 'HAS_REACTION',
      orientation: 'UNDIRECTED'
    },
    RESULTED_IN: {
      type: 'RESULTED_IN',
      orientation: 'UNDIRECTED'
    }
  }
);


CALL gds.louvain.write(
  'myGraph',
  { 
  writeProperty: 'community',
  maxIterations: 10, 
  includeIntermediateCommunities: false
})
YIELD communityCount, modularity;


//to in the Community of the death outcome what are the most drugs appearance in those :
MATCH p=(relatedNodes:Drug)--()--(l:Outcome)
WHERE relatedNodes.community=6249
RETURN relatedNodes as Drug,l,count(p) as Cases
Order by Cases DESC
LIMIT 100;

//to see the drugs that are common in the two
MATCH (n:Outcome)-[r]-()--(relatedNodes:Drug)
WHERE n.community = 4354 
RETURN n.outcome as outcome,relatedNodes as Drug, count(r) as Cases
order by Cases DESC
LIMIT 100;


//to see the drugs that are common in the two
MATCH (n:Outcome)-[r]-()--(relatedNodes:Drug)
WHERE n.community = 4354 AND n.outcome="Life-Threatening"
RETURN n.outcome as outcome,relatedNodes as Drug, count(r) as Cases
order by Cases DESC
LIMIT 100;


//to see the reactions that are common in the two
MATCH (n:Outcome)-[r]-()--(relatedNodes:Reaction)
WHERE n.community = 4354 
RETURN n.outcome as outcome,relatedNodes as Reaction, count(r) as Cases
order by Cases DESC
LIMIT 100;