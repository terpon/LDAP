Extension { #name : 'BERConstruct' }

{ #category : '*LDAP-Spec2' }
BERConstruct >> inspectionItems: aBuilder [
	<inspectorPresentationOrder: 0 title: 'Construct'> 
	^ BERElementTreePresenter new roots: elements; owner: aBuilder; yourself
]
