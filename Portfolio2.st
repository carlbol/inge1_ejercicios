!classDefinition: #PortfolioTest category: 'Portfolio2'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio2'!

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:16:26'!
test01BalanceOfPortfolioWithoutAccountsIsZero

	self assert: 0 equals: Portfolio new balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'NR 5/27/2021 17:36:04'!
test02BalanceOfPortfolioWithAccountsIsSumOfAccountsBalance

	| account portfolio |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: account balance equals: portfolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:23:25'!
test03BalanceOfPortfolioIsCalculatedRecursivelyOnPortfolios

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortofolio |
	
	simplePortfolioAccount := ReceptiveAccount new.
	Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	Withdraw register: 50 on: composedPortfolioAccount.
	composedPortofolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolioAccount balance + simplePortfolio balance) equals: composedPortofolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:15'!
test04PortfolioWithoutAccountsHasNoRegisteredTransaction

	self deny: (Portfolio new hasRegistered: (Deposit for: 100))! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:11'!
test05PortfolioHasRegisteredItsAccountsTransactions

	| account portfolio deposit |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: (portfolio hasRegistered: deposit)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:06'!
test06PortfolioLooksForRegisteredTransactionsRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolio hasRegistered: simplePortfolioAccountDeposit).
	self assert: (composedPortfolio hasRegistered: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:10'!
test07PortfolioHasNoTransactionWhenHasNoAccounts

	self assert: Portfolio new transactions isEmpty! !

!PortfolioTest methodsFor: 'tests' stamp: 'NR 6/22/2020 07:31:19'!
test08PortfolioTransactionsIncludesAllItsAccountsTransactions

	| account portfolio accountDeposit anotherAccount portfolioTransactions anotherAccountWithdraw |
	
	account := ReceptiveAccount new.
	accountDeposit := Deposit register: 100 on: account.
	anotherAccount := ReceptiveAccount new.
	anotherAccountWithdraw := Withdraw register: 100 on: account.
	portfolio := Portfolio with: account.
	
	portfolioTransactions := portfolio transactions.
	
	self assert: 2 equals: portfolioTransactions size.
	self assert: (portfolioTransactions includes: accountDeposit).
	self assert: (portfolioTransactions includes: anotherAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:20'!
test09PortfolioTransactionsAreCalculatedRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit composedPortfolioTransactions |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	composedPortfolioTransactions := composedPortfolio transactions.
	self assert: 2 equals: composedPortfolioTransactions size.
	self assert: (composedPortfolioTransactions includes: simplePortfolioAccountDeposit).
	self assert: (composedPortfolioTransactions includes: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:24'!
test10PortfolioCanNotIncludeTheSameAccountMoreThanOnce

	| account portfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio with: account.
	
	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: portfolio accountsSize.
			self assert: (portfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:28'!
test11PortfolioCanNotIncludeAccountOfItsPortfolios

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	composedPortfolio := Portfolio with: simplePortfolio.
	
	self 
		should: [ composedPortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: composedPortfolio accountsSize.
			self assert: (composedPortfolio accountsIncludes: simplePortfolio) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:32'!
test12PortfolioCanNotIncludeItself

	| account simplePortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	
	self 
		should: [ simplePortfolio add: simplePortfolio ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: simplePortfolio accountsSize.
			self assert: (simplePortfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:01:51'!
test13ComposedPortfolioCanNotHaveParentPortfolioAccount

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio new.
	composedPortfolio := Portfolio with: simplePortfolio.
	composedPortfolio add: account.
	
	self 
		should: [ simplePortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: simplePortfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:12:16'!
test14ComposedPortfolioCanNotHaveAccountOfAnyRootParentRecursively

	| account leftParentPortfolio leftRootParentPortfolio portfolio rightParentPortfolio rightRootParentPortfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio new.
	leftParentPortfolio := Portfolio with: portfolio .
	leftRootParentPortfolio := Portfolio with: leftParentPortfolio.
	leftRootParentPortfolio add: account.
	
	rightParentPortfolio := Portfolio with: portfolio .
	rightRootParentPortfolio := Portfolio with: rightParentPortfolio.
	rightRootParentPortfolio add: account.

	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/29/2019 16:31:18'!
test15PortfolioCanNotIncludeAnyOfTheComposedAccountOfPortfolioToAdd

	| portfolioToAdd portfolioToModify rootPortfolio sharedAccount |
	
	sharedAccount := ReceptiveAccount new.
	portfolioToModify := Portfolio new.
	rootPortfolio := Portfolio with: sharedAccount with: portfolioToModify.
	portfolioToAdd := Portfolio with: sharedAccount.
	
	self 
		should: [ portfolioToModify add: portfolioToAdd ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolioToModify accountsIsEmpty ]! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio2'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio2'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:48'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:54'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:02'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:32'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:46'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:54'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 100.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:21:24'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 100 on: account1.
		
	self assert: 1 equals: account1 transactions size .
	self assert: (account1 transactions includes: deposit1).
! !


!classDefinition: #TransferTests category: 'Portfolio2'!
TestCase subclass: #TransferTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio2'!

!TransferTests methodsFor: 'as yet unclassified' stamp: 'CB 10/31/2025 21:57:50'!
test01AccountATransferToAccountBAndAccountBBalanceIsUpdated

	| transferringAccount transferredAccount |
	transferringAccount := ReceptiveAccount new.
	transferredAccount := ReceptiveAccount new.
	
	transferringAccount transfers: 100 to: transferredAccount.
	
	self assert: transferringAccount balance equals: -100.
	
	
	! !

!TransferTests methodsFor: 'as yet unclassified' stamp: 'CB 10/31/2025 21:57:37'!
test02AccountATransferToAccountBAndAccountBBalanceIsUpdated

	| transferringAccount transferredAccount |
	transferringAccount := ReceptiveAccount new.
	transferredAccount := ReceptiveAccount new.
	
	transferringAccount transfers: 100 to: transferredAccount.
	
	self assert: transferredAccount balance equals: 100.
	
	
	! !

!TransferTests methodsFor: 'as yet unclassified' stamp: 'CB 11/4/2025 13:05:13'!
test05AccountWith0TransactionsHasAccountSummaryWithABalanceOfZero

	| account |
	account := ReceptiveAccount new.
	
	self assert: account accountSummaryReport equals: (OrderedCollection with: 'Balance = 0')
	
	
	! !

!TransferTests methodsFor: 'as yet unclassified' stamp: 'CB 11/4/2025 20:05:07'!
test06AccountWithDepositAndWithdrawHasCorrespondingStringsAccountSummary

	| account |
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
	Withdraw register: 50 on: account.	
	
	self assert: account accountSummaryReport equals: (OrderedCollection with: 'Depósito por 100.' with: 'Extracción por 50.' with: 'Extracción por 50.' with: 'Balance = 0').
	
	
	! !

!TransferTests methodsFor: 'as yet unclassified' stamp: 'CB 11/4/2025 13:05:13'!
test07AccountThatSentATransferHasCorrespondingStringInAccountSummary

	| transferringAccount transferredAccount |
	transferringAccount := ReceptiveAccount new.
	transferredAccount  := ReceptiveAccount new.
	Transfer from: transferringAccount  to: transferredAccount of: 100.
	
	
	self assert: transferringAccount accountSummaryReport equals: (OrderedCollection with: 'Salida por transferencia de 100.' with: 'Balance = -100').
	
	
	! !

!TransferTests methodsFor: 'as yet unclassified' stamp: 'CB 11/4/2025 13:05:13'!
test08AccountThatReceivedATransferHasCorrespondingStringInAccountSummary

	| transferringAccount transferredAccount |
	transferringAccount := ReceptiveAccount new.
	transferredAccount  := ReceptiveAccount new.
	Transfer from: transferringAccount  to: transferredAccount of: 100.
	
	
	self assert: transferredAccount accountSummaryReport equals: (OrderedCollection with: 'Entrada por transferencia de 100.' with: 'Balance = 100').
	
	
	! !

!TransferTests methodsFor: 'as yet unclassified' stamp: 'CB 11/4/2025 13:06:18'!
test09AccountThatHasReceivedAndSentTransfersProducesExpectedNetTransferReport

	| accountA accountB |
	accountA := ReceptiveAccount new.
	accountB  := ReceptiveAccount new.
	Transfer from: accountB  to: accountA of: 50.
	Transfer from: accountA  to: accountB of: 25.
	
	
	self assert: accountA netTransferReport equals: 25.
	
	
	! !

!TransferTests methodsFor: 'as yet unclassified' stamp: 'CB 11/4/2025 20:05:48'!
test0xAccountWithDepositAndMultipleWithdrawShouldBeSummedPreguntoxd

	| account |
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
	Withdraw register: 50 on: account.	
	
	self assert: account accountSummaryReport equals: (OrderedCollection with: 'Depósito por 100.' with: 'Extracción por 50.' with: 'Extracción por 50.' with: 'Balance = 0').
	
	
	! !

!TransferTests methodsFor: 'as yet unclassified' stamp: 'CB 11/4/2025 21:47:32'!
test0xHayQUeHacerUnParDeNavegacion

	| transferringAccount transferredAccount |
	transferringAccount := ReceptiveAccount new.
	transferredAccount := ReceptiveAccount new.
	
	transferringAccount transfers: 100 to: transferredAccount.
	
	self assert: transferredAccount balance equals: 100.
	
	
	! !

!TransferTests methodsFor: 'as yet unclassified' stamp: 'CB 11/4/2025 11:59:03'!
test0xnavigation

	| transferringAccount transferredAccount |
	transferringAccount := ReceptiveAccount new.
	transferredAccount := ReceptiveAccount new.
	
	transferringAccount transfers: 100 to: transferredAccount.
	
	self assert: transferredAccount balance equals: 100.
	
	
	! !

!TransferTests methodsFor: 'as yet unclassified' stamp: 'CB 11/4/2025 13:12:49'!
test10AccountWithNonTransferTransactionsThatHasReceivedSentTransfersProducesExpectedNetTransferReport

	| accountA accountB |
	accountA := ReceptiveAccount new.
	accountB  := ReceptiveAccount new.
	Transfer from: accountB  to: accountA of: 50.
	Transfer from: accountA  to: accountB of: 25.
	Deposit register: 100 on: accountA.
	Withdraw register: 45 on: accountB.
	
	
	self assert: accountA netTransferReport equals: 25.
	
	
	! !

!TransferTests methodsFor: 'as yet unclassified' stamp: 'CB 11/4/2025 17:56:31'!
test11EmptyPortfolioHasOnlyOneEntryAndIts0

	| portfolio  |
	portfolio := Portfolio new.
	
	self assert: portfolio accountSummaryReport equals: (OrderedCollection with: 'Balance = 0').
	
	
	! !

!TransferTests methodsFor: 'as yet unclassified' stamp: 'CB 11/4/2025 19:44:18'!
test12PortfolioWithAnAccountHasItsAccountSummaryReport

	| portfolio  account |
	portfolio := Portfolio new.
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
	Deposit register: 150 on: account.
	
	portfolio add: account.
	
	self assert: portfolio accountSummaryReport equals: account accountSummaryReport .
	
	
	! !

!TransferTests methodsFor: 'as yet unclassified' stamp: 'CB 11/4/2025 20:43:10'!
test13PortfolioWithMultipleAccountsHasCombinedSummaryReports

	| portfolio  accountA accountB|
	portfolio := Portfolio new.
	
	accountA := ReceptiveAccount new.
	Deposit register: 100 on: accountA.
	Withdraw register: 50 on: accountA.
	
	accountB := ReceptiveAccount new.
	Deposit register: 100 on: accountB.
	Withdraw register: 50 on: accountB.
	
	portfolio add: accountA.
	portfolio add: accountB.
	
	self assert: portfolio accountSummaryReport equals: accountA accountSummaryReport .
	
	
	! !

!TransferTests methodsFor: 'as yet unclassified' stamp: 'CB 11/4/2025 20:13:32'!
test14AccountsInvolvedInTransactionRegisterTheirRespectiveLegs

	| transferringAccount transferredAccount transfer |
	transferringAccount := ReceptiveAccount new.
	transferredAccount := ReceptiveAccount new.
	
	transfer := transferringAccount transfers: 100 to: transferredAccount.
	
	self assert: (	transferringAccount hasRegistered: transfer withdrawLeg ).
	self assert: (	transferredAccount hasRegistered: transfer depositLeg ).
	
	
	! !

!TransferTests methodsFor: 'as yet unclassified' stamp: 'CB 11/4/2025 21:48:55'!
test1XPortfolioNetTransfer

	| transferringAccount transferredAccount transfer |
	transferringAccount := ReceptiveAccount new.
	transferredAccount := ReceptiveAccount new.
	
	transfer := transferringAccount transfers: 100 to: transferredAccount.
	
	self assert: (	transferringAccount hasRegistered: transfer withdrawLeg ).
	self assert: (	transferredAccount hasRegistered: transfer depositLeg ).
	
	
	! !


!classDefinition: #Account category: 'Portfolio2'!
Object subclass: #Account
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio2'!

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:23:47'!
hasRegistered: aTransaction

	self subclassResponsibility ! !

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:24:25'!
isComposedBy: anAccount

	self subclassResponsibility ! !


!Account methodsFor: 'balance' stamp: 'HAW 5/25/2019 12:23:40'!
balance

	self subclassResponsibility ! !


!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:27'!
addTransactionsTo: aCollectionOfTransactions

	self subclassResponsibility ! !

!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:15'!
transactions

	self subclassResponsibility ! !


!Account methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:24:04'!
addedTo: aPortfolio

	self subclassResponsibility ! !


!Account methodsFor: 'transfer' stamp: 'CB 11/3/2025 20:33:26'!
transfers: anAmountOfMoney to: transferredAccount

	self subclassResponsibility! !


!classDefinition: #Portfolio category: 'Portfolio2'!
Account subclass: #Portfolio
	instanceVariableNames: 'accounts parents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio2'!

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:20'!
accountsIncludes: anAccount

	^accounts includes: anAccount ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:05:04'!
accountsIsEmpty
	
	^accounts isEmpty ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:06'!
accountsSize
	
	^accounts size! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:19:20'!
add: accountToAdd

	self assertCanAdd: accountToAdd.
		
	accounts add: accountToAdd.
	accountToAdd addedTo: self 
	! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:17:31'!
rootParents
	
	| rootParents |
	
	rootParents := Set new.
	self addRootParentsTo: rootParents.
	
	^ rootParents! !


!Portfolio methodsFor: 'initialization' stamp: 'HAW 5/25/2019 12:03:18'!
initialize

	accounts := OrderedCollection new.
	parents := OrderedCollection new.! !


!Portfolio methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:19:36'!
balance
	
	^accounts sum: [ :anAccount | anAccount balance ] ifEmpty: [ 0 ]! !


!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:42:55'!
addTransactionsTo: aCollectionOfTransactions

	accounts do: [ :anAccount | anAccount addTransactionsTo: aCollectionOfTransactions ]! !

!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:32'!
transactions
	
	| transactions |
	
	transactions := OrderedCollection new.
	accounts do: [ :anAccount | anAccount addTransactionsTo: transactions ].
	
	^transactions ! !


!Portfolio methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:02:59'!
addedTo: aPortfolio 
	
	parents add: aPortfolio ! !


!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:20:56'!
anyRootParentIsComposedBy: accountToAdd

	^self rootParents anySatisfy: [ :aParent | aParent isComposedBy: accountToAdd]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:28:29'!
hasRegistered: aTransaction

	^accounts anySatisfy: [ :anAccount | anAccount hasRegistered: aTransaction ]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/29/2019 16:24:54'!
isComposedBy: anAccount

	^ self = anAccount or: [ accounts anySatisfy: [ :composedAccount | (composedAccount isComposedBy: anAccount) or: [ anAccount isComposedBy: composedAccount ]]]! !


!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:17:31'!
addRootParentsTo: rootParents

	parents 
		ifEmpty: [ rootParents add: self ] 
		ifNotEmpty: [ parents do: [ :aParent | aParent addRootParentsTo: rootParents ]]! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:20:36'!
assertCanAdd: accountToAdd

	(self anyRootParentIsComposedBy: accountToAdd) ifTrue: [ self signalCanNotAddAccount ].
! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 11:48:34'!
signalCanNotAddAccount
	
	self error: self class canNotAddAccountErrorMessage! !


!Portfolio methodsFor: 'transfer' stamp: 'CB 11/3/2025 20:34:37'!
transfers: anAmountOfMoney to: transferredAccount 
	
	^Transfer from: self to: transferredAccount of: anAmountOfMoney.! !


!Portfolio methodsFor: 'reports' stamp: 'CB 11/4/2025 19:34:46'!
accountSummaryReport

	| accountSummary totalBalance balanceSummary |
	accountSummary := accounts inject: OrderedCollection new into: [:collectionOfTransactionSummaries :anAccount | 
	collectionOfTransactionSummaries addAll: anAccount accountSummaryReportWithoutBalance ].

	totalBalance := accounts sum: [:anAccount | anAccount balance] ifEmpty: [0].
	
	balanceSummary := 'Balance = ', totalBalance asString.
	accountSummary add:balanceSummary.
	^ accountSummary.
	
	
		
	! !

!Portfolio methodsFor: 'reports' stamp: 'CB 11/4/2025 21:38:22'!
netTransferReport

	^ accounts sum: [:anAccount | anAccount netTransferReport] ifEmpty: [0].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'Portfolio2'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:48:55'!
canNotAddAccountErrorMessage
	
	^'Can not add repeated account to a portfolio'! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:18:21'!
with: anAccount

	^self new 
		add: anAccount;
		yourself! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:23:59'!
with: anAccount with: anotherAccount

	^self new 
		add: anAccount;
		add: anotherAccount;
		yourself! !


!classDefinition: #ReceptiveAccount category: 'Portfolio2'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio2'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:35'!
initialize

	super initialize.
	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:52'!
addTransactionsTo: aCollectionOfTransactions

	aCollectionOfTransactions addAll: transactions ! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:24:46'!
balance

	^transactions 
		inject: 0
		into: [ :currentBalance :transaction | transaction affectBalance: currentBalance ]! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/21/2019 18:55:56'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:54:51'!
isComposedBy: anAccount

	^self = anAccount ! !


!ReceptiveAccount methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:03:32'!
addedTo: aPortfolio 
	
	! !


!ReceptiveAccount methodsFor: 'transfer' stamp: 'CB 11/3/2025 20:34:26'!
transfers: anAmountOfMoney to: transferredAccount 
	
	^Transfer from: self to: transferredAccount of: anAmountOfMoney.! !


!ReceptiveAccount methodsFor: 'reports' stamp: 'CB 11/4/2025 19:25:52'!
accountSummaryReport
	|accountSummary balanceSummary |
	accountSummary := self accountSummaryReportWithoutBalance.
	balanceSummary := 'Balance = ', self balance asString.
	accountSummary add:balanceSummary.
	^ accountSummary! !

!ReceptiveAccount methodsFor: 'reports' stamp: 'CB 11/4/2025 19:25:52'!
accountSummaryReportWithoutBalance

	^ transactions collect: [:aTransaction | aTransaction transactionSummary]! !

!ReceptiveAccount methodsFor: 'reports' stamp: 'CB 11/4/2025 13:08:24'!
netTransferReport
	^ transactions sum: [:aTransaction | aTransaction transferValue].! !


!classDefinition: #AccountTransaction category: 'Portfolio2'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio2'!

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:39'!
affectBalance: aBalance

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'reports' stamp: 'CB 11/4/2025 13:02:40'!
transactionSummary

	self subclassResponsibility! !

!AccountTransaction methodsFor: 'reports' stamp: 'CB 11/4/2025 13:10:40'!
transferValue

	^ 0.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio2'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/21/2019 18:54:27'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio2'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio2'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !


!Deposit methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:02'!
affectBalance: aBalance

	^aBalance + value ! !


!Deposit methodsFor: 'reports' stamp: 'CB 11/4/2025 12:14:20'!
transactionSummary
		^ 'Depósito por ', value asString , '.'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio2'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #TransferLeg category: 'Portfolio2'!
AccountTransaction subclass: #TransferLeg
	instanceVariableNames: 'transfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio2'!

!TransferLeg methodsFor: 'transfer' stamp: 'CB 11/4/2025 20:18:47'!
transfer
	^ transfer .! !


!TransferLeg methodsFor: 'initialization' stamp: 'CB 11/4/2025 20:22:05'!
initializeBy: aTransferringAccount in: aTransfer 
	transfer := aTransfer.
	aTransferringAccount register: self.! !


!classDefinition: #ReceivedTransfer category: 'Portfolio2'!
TransferLeg subclass: #ReceivedTransfer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio2'!

!ReceivedTransfer methodsFor: 'balanceUpdate' stamp: 'CB 10/31/2025 21:50:46'!
affectBalance: currentBalance 
	^ currentBalance + transfer receivedTransferValue.! !


!ReceivedTransfer methodsFor: 'reports' stamp: 'CB 11/4/2025 12:53:26'!
transactionSummary
	^'Entrada por transferencia de ', transfer value asString , '.'! !


!ReceivedTransfer methodsFor: 'transfer' stamp: 'CB 11/4/2025 13:09:09'!
transferValue
	^ transfer receivedTransferValue.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ReceivedTransfer class' category: 'Portfolio2'!
ReceivedTransfer class
	instanceVariableNames: ''!

!ReceivedTransfer class methodsFor: 'instance creation' stamp: 'CB 10/31/2025 21:47:10'!
by: transferredAccount in: aTransfer 
	
	^self new initializeBy: transferredAccount in: aTransfer ! !

!ReceivedTransfer class methodsFor: 'instance creation' stamp: 'CB 10/31/2025 21:24:51'!
for: aValue 
	^self new initializeFor: aValue ! !


!classDefinition: #SentTransfer category: 'Portfolio2'!
TransferLeg subclass: #SentTransfer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio2'!

!SentTransfer methodsFor: 'balanceUpdate' stamp: 'CB 10/31/2025 21:49:07'!
affectBalance: currentBalance 
	^currentBalance + transfer sentTransferValue.! !


!SentTransfer methodsFor: 'reports' stamp: 'CB 11/4/2025 12:44:58'!
transactionSummary
	^'Salida por transferencia de ', transfer value asString , '.'! !


!SentTransfer methodsFor: 'transfer' stamp: 'CB 11/4/2025 13:09:47'!
transferValue
	^ transfer sentTransferValue ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SentTransfer class' category: 'Portfolio2'!
SentTransfer class
	instanceVariableNames: ''!

!SentTransfer class methodsFor: 'as yet unclassified' stamp: 'CB 10/31/2025 21:23:48'!
for: aValue 
	^ self new initializeFor: aValue! !


!SentTransfer class methodsFor: 'instance creation' stamp: 'CB 10/31/2025 21:44:10'!
by: transferringAccount1 in: aTransfer 

	^self new initializeBy: transferringAccount1 in: aTransfer ! !


!classDefinition: #Withdraw category: 'Portfolio2'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio2'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !


!Withdraw methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:15'!
affectBalance: aBalance

	^aBalance - value! !


!Withdraw methodsFor: 'reports' stamp: 'CB 11/4/2025 12:16:02'!
transactionSummary
	^ 'Extracción por ', value asString , '.'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio2'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Transfer category: 'Portfolio2'!
Object subclass: #Transfer
	instanceVariableNames: 'transferringAccount transferredAccount amountOfMoney withdrawLeg depositLeg'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio2'!

!Transfer methodsFor: 'initialization' stamp: 'CB 11/4/2025 19:55:48'!
initializeFrom: aTransferringAccount to: aTransferredAccount of: anAmountOfMoney 
	transferringAccount := aTransferringAccount.
	transferredAccount := aTransferredAccount.
	amountOfMoney := anAmountOfMoney.
	
	withdrawLeg := SentTransfer by: transferringAccount in: self.
	depositLeg := ReceivedTransfer by: transferredAccount in: self.
	
	! !


!Transfer methodsFor: 'balance' stamp: 'CB 10/31/2025 21:51:01'!
receivedTransferValue
	^ amountOfMoney ! !

!Transfer methodsFor: 'balance' stamp: 'CB 10/31/2025 21:49:57'!
sentTransferValue
	^ amountOfMoney negated.! !


!Transfer methodsFor: 'as yet unclassified' stamp: 'CB 11/4/2025 12:46:36'!
value
	^ amountOfMoney.! !


!Transfer methodsFor: 'legs' stamp: 'CB 11/4/2025 19:56:31'!
depositLeg

	^ depositLeg.
! !

!Transfer methodsFor: 'legs' stamp: 'CB 11/4/2025 19:56:39'!
withdrawLeg

	^ withdrawLeg ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transfer class' category: 'Portfolio2'!
Transfer class
	instanceVariableNames: ''!

!Transfer class methodsFor: 'instance creation' stamp: 'CB 10/31/2025 21:37:57'!
from: aReceptiveAccount to: transferredAccount of: anAmountOfMoney 
	^self new initializeFrom: aReceptiveAccount to: transferredAccount of: anAmountOfMoney ! !
