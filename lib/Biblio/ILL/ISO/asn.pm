package Biblio::ILL::ISO::asn;

=head1 NAME

Biblio::ILL::ISO::asn

=cut

=head1 VERSION

Version 0.03

=cut

our $VERSION = '0.03';
#---------------------------------------------------------------------------
# Mods
# 0.03 - 2003.10.26 - Added POD documentation
# 0.02 - 2003.07.17 - Changed Date-Time from EXPLICIT SEQUENCE to SEQUENCE,
#                     to bring it in line with the nlc-bnc ASN.1
# 0.01 - 2003.07.15 - original version (nlc-bnc version whacked to be
#                     parsable by Convert::ASN1)
#---------------------------------------------------------------------------

=head1 DESCRIPTION

Biblio::ILL::ISO::asn contains the ASN.1 definitions, accessible through $desc.

=head1 USES

 None.

=head1 USED IN

 Biblio::ILL::ISO::ISO

=cut

our $desc = <<'_END_OF_ASN_';

-- use of parameters and types is to be consistent with their definitions in clause 3

-- ISO-10161-ILL-1 DEFINITIONS EXPLICIT TAGS ::=

--BEGIN
-- ISO-10161-ILL-1 refers to the ILL ISO standard 10161 version 1
-- and version 2 as specified in ISO standard 10161 Amendment 1

ILL-APDU ::= CHOICE {
	iLL-Request			ILL-Request,
	forward-Notification		Forward-Notification,
	shipped				Shipped,
	iLL-Answer			ILL-Answer,
	conditional-Reply		Conditional-Reply,
	cancel				Cancel,
	cancel-Reply			Cancel-Reply,
	received			Received,
	recall				Recall,
	returned			Returned,
	checked-In			Checked-In,
	overdue				Overdue,
	renew				Renew,
	renew-Answer			Renew-Answer,
	lost				Lost,
	damaged				Damaged,
	message				Message,
	status-Query			Status-Query,
	status-Or-Error-Report		Status-Or-Error-Report,
	expired				Expired
	}

-- The tagging scheme used in the APDU definitions is as follows:
-- each named type that is a component type of an APDU definition is assigned a different tag
-- that is unique within the set of APDU definitions.  Where these component types themselves
-- have structure, the tagging within such type definitions has only local scope. 

ILL-Request ::= [APPLICATION 1] EXPLICIT SEQUENCE {
	protocol-version-num	[0]	IMPLICIT INTEGER, -- {
				-- version-1 (1),
				-- version-2 (2)
				--},
	transaction-id	[1]	IMPLICIT Transaction-Id,
	service-date-time	[2]	IMPLICIT Service-Date-Time,
	requester-id	[3]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	responder-id	[4]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	transaction-type	[5]	IMPLICIT Transaction-Type, --DEFAULT 1,
	delivery-address	[6]	IMPLICIT Delivery-Address OPTIONAL, 
	delivery-service		Delivery-Service OPTIONAL,
	billing-address	[8]	IMPLICIT Delivery-Address OPTIONAL,
	iLL-service-type	[9]	IMPLICIT SEQUENCE OF ILL-Service-Type, --  SIZE (1..5)
		-- this sequence is a list, in order of preference
-- DC - 'EXTERNAL' is not supported in Convert::ASN1
--	responder-specific-service	[10]	EXTERNAL OPTIONAL,
--		-- use direct reference style
	requester-optional-messages	[11]	IMPLICIT Requester-Optional-Messages-Type,
	search-type	[12]	IMPLICIT Search-Type OPTIONAL,
	supply-medium-info-type 	[13]	IMPLICIT SEQUENCE OF Supply-Medium-Info-Type OPTIONAL, -- SIZE (1..7)
		-- this sequence is a list, in order of preference,
		-- with a maximum number of 7 entries
	place-on-hold	[14]	IMPLICIT Place-On-Hold-Type, --DEFAULT 3,
	client-id	[15]	IMPLICIT Client-Id OPTIONAL,     
	item-id	[16]	IMPLICIT Item-Id,
-- DC - 'EXTERNAL' definition (see Supplemental-Item-Description)
--	supplemental-item-description	[17]	IMPLICIT Supplemental-Item-Description OPTIONAL,
	cost-info-type	[18]	IMPLICIT Cost-Info-Type OPTIONAL,
	copyright-compliance	[19]	ILL-String OPTIONAL,
	third-party-info-type	[20]	IMPLICIT Third-Party-Info-Type OPTIONAL,
		-- mandatory when initiating a FORWARD service or an
		-- ILL-REQUEST service for a partitioned ILL sub-
		-- transaction or when initiating an ILL-REQUEST service for
		-- an ILL sub-transaction if the received ILL-REQUEST
		-- included an "already-tried-list";optional otherwise
	retry-flag	[21]	IMPLICIT BOOLEAN, -- DEFAULT FALSE,
	forward-flag	[22]	IMPLICIT BOOLEAN, -- DEFAULT FALSE,
	requester-note	[46]	ILL-String OPTIONAL,
	forward-note	[47]	ILL-String OPTIONAL,
	iLL-request-extensions 	[49]	IMPLICIT SEQUENCE OF Extension OPTIONAL
	--iLL-request-extensions 	[49]	IMPLICIT SEQUENCE OF Extension
 	}

Forward-Notification ::= [APPLICATION 2] SEQUENCE {
	protocol-version-num	[0]	IMPLICIT INTEGER, -- {
				-- version-1 (1),
				-- version-2 (2)
				-- },
	transaction-id	[1]	IMPLICIT Transaction-Id,   
	service-date-time	[2]	IMPLICIT Service-Date-Time,
	requester-id	[3]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	responder-id	[4]	IMPLICIT System-Id,
		-- mandatory in this APDU
	responder-address	[24]	IMPLICIT System-Address OPTIONAL,
	intermediary-id	[25]	IMPLICIT System-Id,
	notification-note	[48]	ILL-String OPTIONAL,
	forward-notification-extensions	[49]	IMPLICIT SEQUENCE OF Extension OPTIONAL
	}

Shipped ::= [APPLICATION 3] SEQUENCE {
	protocol-version-num	[0]	IMPLICIT INTEGER, -- {
				-- version-1 (1),
				-- version-2 (2)
				-- },
	transaction-id	[1]	IMPLICIT Transaction-Id,   
	service-date-time	[2]	IMPLICIT Service-Date-Time,
	requester-id	[3]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	responder-id	[4]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	responder-address	[24]	IMPLICIT System-Address OPTIONAL,
	intermediary-id	[25]	IMPLICIT System-Id OPTIONAL,
	supplier-id	[26]	IMPLICIT System-Id OPTIONAL,
	client-id	[15]	IMPLICIT Client-Id OPTIONAL,
	transaction-type	[5]	IMPLICIT Transaction-Type, --DEFAULT 1,
-- DC - 'EXTERNAL' definition (see Supplemental-Item-Description)
--	supplemental-item-description	[17]	IMPLICIT Supplemental-Item-Description OPTIONAL,
	shipped-service-type	[27]	IMPLICIT Shipped-Service-Type,
	responder-optional-messages	[28]	IMPLICIT Responder-Optional-Messages-Type
				OPTIONAL,
	supply-details	[29]	IMPLICIT Supply-Details,
	return-to-address	[30]	IMPLICIT Postal-Address OPTIONAL,
	responder-note	[46]	ILL-String OPTIONAL,
	shipped-extensions	[49]	IMPLICIT SEQUENCE OF Extension OPTIONAL
	}

ILL-Answer ::= [APPLICATION 4] SEQUENCE {
	protocol-version-num	[0]	IMPLICIT INTEGER, -- {
				-- version-1 (1),
				-- version-2 (2)
				-- },
	transaction-id	[1]	IMPLICIT Transaction-Id,
	service-date-time	[2]	IMPLICIT Service-Date-Time,
	requester-id	[3]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	responder-id	[4]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	transaction-results	[31]	IMPLICIT Transaction-Results,
	results-explanation	[32]	Results-Explanation OPTIONAL,
		-- dc hmm
		-- optional if transaction-results equals RETRY, UNFILLED,
		-- WILL-SUPPLY or HOLD-PLACED;
		-- required if transaction-results equals CONDITIONAL,
		-- LOCATIONS-PROVIDED or ESTIMATE
-- DC - 'EXTERNAL' is not supported in Convert::ASN1
--	responder-specific-results	[33]	EXTERNAL OPTIONAL,
		-- this type is mandatory if results-explanation
		-- chosen for any result 
		-- has the value "responder-specific".
-- DC - 'EXTERNAL' definition (see Supplemental-Item-Description)
--	supplemental-item-description	[17]	IMPLICIT Supplemental-Item-Description OPTIONAL,
	send-to-list	[23]	IMPLICIT Send-To-List-Type OPTIONAL,
	already-tried-list	[34]	IMPLICIT Already-Tried-List-Type OPTIONAL,
	responder-optional-messages	[28]	IMPLICIT Responder-Optional-Messages-Type
				OPTIONAL,
	responder-note	[46]	ILL-String OPTIONAL,
	ill-answer-extensions	[49]	IMPLICIT SEQUENCE OF Extension OPTIONAL
	}

Conditional-Reply ::= [APPLICATION 5] SEQUENCE {
	protocol-version-num	[0]	IMPLICIT INTEGER, -- {
				-- version-1 (1),
				-- version-2 (2)
				-- },
	transaction-id	[1]	IMPLICIT Transaction-Id,
	service-date-time	[2]	IMPLICIT Service-Date-Time,
	requester-id	[3]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	responder-id	[4]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	answer	[35]	IMPLICIT BOOLEAN,
	requester-note	[46]	ILL-String OPTIONAL,
	conditional-reply-extensions	[49]	IMPLICIT SEQUENCE OF Extension OPTIONAL
	}

Cancel ::= [APPLICATION 6] SEQUENCE {
	protocol-version-num	[0]	IMPLICIT INTEGER, -- {
				-- version-1 (1),
				-- version-2 (2)
				-- },
	transaction-id	[1]	IMPLICIT Transaction-Id,
	service-date-time	[2]	IMPLICIT Service-Date-Time,
	requester-id	[3]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	responder-id	[4]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	requester-note	[46]	ILL-String OPTIONAL,
	cancel-extensions	[49]	IMPLICIT SEQUENCE OF Extension OPTIONAL
	}

Cancel-Reply ::= [APPLICATION 7] SEQUENCE {
	protocol-version-num	[0]	IMPLICIT INTEGER, -- {
				 -- version-1 (1),
				 -- version-2 (2)
				 -- },
	transaction-id	[1]	IMPLICIT Transaction-Id,
	service-date-time	[2]	IMPLICIT Service-Date-Time,
	requester-id	[3]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	responder-id	[4]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	answer	[35]	IMPLICIT BOOLEAN,
	responder-note	[46]	ILL-String OPTIONAL,
	cancel-reply-extensions	[49]	IMPLICIT SEQUENCE OF Extension OPTIONAL
	}

Received ::= [APPLICATION 8] SEQUENCE { 
	protocol-version-num	[0]	IMPLICIT INTEGER, -- {
			 -- version-1 (1),
			 -- version-2 (2)
			 -- },
	transaction-id	[1]	IMPLICIT Transaction-Id,
	service-date-time	[2]	IMPLICIT Service-Date-Time,
	requester-id	[3]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	responder-id	[4]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	supplier-id	[26]	IMPLICIT System-Id OPTIONAL,
-- DC - 'EXTERNAL' definition (see Supplemental-Item-Description)
--	supplemental-item-description	[17]	IMPLICIT Supplemental-Item-Description OPTIONAL,
	date-received	[36]	IMPLICIT ISO-Date,
	shipped-service-type	[27]	IMPLICIT Shipped-Service-Type,
	requester-note	[46]	ILL-String OPTIONAL,
	received-extensions	[49]	IMPLICIT SEQUENCE OF Extension OPTIONAL
	}

Recall ::= [APPLICATION 9] SEQUENCE {  
	protocol-version-num	[0]	IMPLICIT INTEGER, -- {
				-- version-1 (1),
				-- version-2 (2)
				-- },
	transaction-id	[1]	IMPLICIT Transaction-Id,   
	service-date-time	[2]	IMPLICIT Service-Date-Time,
	requester-id	[3]	IMPLICIT System-Id OPTIONAL, 
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	responder-id	[4]	IMPLICIT System-Id OPTIONAL, 
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	responder-note	[46]	ILL-String OPTIONAL,
	recall-extensions	[49]	IMPLICIT SEQUENCE OF Extension OPTIONAL
	}

Returned ::= [APPLICATION 10] SEQUENCE { 
	protocol-version-num	[0]	IMPLICIT INTEGER, -- {
				-- version-1 (1),
				-- version-2 (2)
				-- },
	transaction-id	[1]	IMPLICIT Transaction-Id,
	service-date-time	[2]	IMPLICIT Service-Date-Time,
	requester-id	[3]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	responder-id	[4]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
-- DC - 'EXTERNAL' definition (see Supplemental-Item-Description)
--	supplemental-item-description	[17]	IMPLICIT Supplemental-Item-Description OPTIONAL,
	date-returned	[37]	IMPLICIT ISO-Date,
	returned-via	[38]	Transportation-Mode OPTIONAL,
	insured-for	[39]	IMPLICIT Amount OPTIONAL,
	requester-note	[46]	ILL-String OPTIONAL,
	returned-extensions	[49]	IMPLICIT SEQUENCE OF Extension OPTIONAL
	}

Checked-In ::= [APPLICATION 11] SEQUENCE {
	protocol-version-num	[0]	IMPLICIT INTEGER, -- {
				-- version-1 (1),
				-- version-2 (2)
				-- },
	transaction-id	[1]	IMPLICIT Transaction-Id,   
	service-date-time	[2]	IMPLICIT Service-Date-Time,
	requester-id	[3]	IMPLICIT System-Id OPTIONAL, 
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	responder-id	[4]	IMPLICIT System-Id OPTIONAL, 
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	date-checked-in	[40]	IMPLICIT ISO-Date,
	responder-note	[46]	ILL-String OPTIONAL,
	checked-in-extensions	[49]	IMPLICIT SEQUENCE OF Extension OPTIONAL
	}

Overdue ::= [APPLICATION 12] SEQUENCE { 
	protocol-version-num	[0]	IMPLICIT INTEGER, -- {
				-- version-1 (1),
				-- version-2 (2)
				-- },
	transaction-id	[1]	IMPLICIT Transaction-Id,
	service-date-time	[2]	IMPLICIT Service-Date-Time,
	requester-id	[3]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	responder-id	[4]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	date-due	[41]	IMPLICIT Date-Due,
	responder-note	[46]	ILL-String OPTIONAL,
	overdue-extensions	[49]	SEQUENCE OF Extension OPTIONAL
	}

Renew ::= [APPLICATION 13] SEQUENCE {
	protocol-version-num	[0]	IMPLICIT INTEGER, -- {
				-- version-1 (1),
				-- version-2 (2)
				-- },
	transaction-id	[1]	IMPLICIT Transaction-Id,   
	service-date-time	[2]	IMPLICIT Service-Date-Time,
	requester-id	[3]	IMPLICIT System-Id OPTIONAL,   
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	responder-id	[4]	IMPLICIT System-Id OPTIONAL,   
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	desired-due-date	[42]	IMPLICIT ISO-Date OPTIONAL,
	requester-note	[46]	ILL-String OPTIONAL,
	renew-extensions	[49]	IMPLICIT SEQUENCE OF Extension OPTIONAL
	}

Renew-Answer ::= [APPLICATION 14] SEQUENCE {
	protocol-version-num	[0]	IMPLICIT INTEGER, -- {
				-- version-1 (1),
				-- version-2 (2)
				-- },
	transaction-id	[1]	IMPLICIT Transaction-Id,   
	service-date-time	[2]	IMPLICIT Service-Date-Time,
	requester-id	[3]	IMPLICIT System-Id OPTIONAL,   
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	responder-id	[4]	IMPLICIT System-Id OPTIONAL,   
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	answer	[35]	IMPLICIT BOOLEAN,
	date-due	[41]	IMPLICIT Date-Due OPTIONAL,
	responder-note	[46]	ILL-String OPTIONAL,
	renew-answer-extensions	[49]	IMPLICIT SEQUENCE OF Extension OPTIONAL
	}

Lost ::= [APPLICATION 15] SEQUENCE {
	protocol-version-num	[0]	IMPLICIT INTEGER, -- {
				-- version-1 (1),
				-- version-2 (2)
				-- },
	transaction-id	[1]	IMPLICIT Transaction-Id,   
	service-date-time	[2]	IMPLICIT Service-Date-Time,
	requester-id	[3]	IMPLICIT System-Id OPTIONAL,   
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	responder-id	[4]	IMPLICIT System-Id OPTIONAL,   
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	note	[46]	ILL-String OPTIONAL,
	lost-extensions	[49]	IMPLICIT SEQUENCE OF Extension OPTIONAL
	}

Damaged ::= [APPLICATION 16] SEQUENCE { 
	protocol-version-num	[0]	IMPLICIT INTEGER, -- {
				-- version-1 (1),
				-- version-2 (2)
				-- },
	transaction-id	[1]	IMPLICIT Transaction-Id,
	service-date-time	[2]	IMPLICIT Service-Date-Time,
	requester-id	[3]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	responder-id	[4]	IMPLICIT System-Id OPTIONAL, 
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	damaged-details	[51]	IMPLICIT Damaged-Details OPTIONAL,
		-- this parameter may only be present in APDUs with a
		-- protocol-version-num value of 2 or greater
	note	[46]	ILL-String OPTIONAL,
	damaged-extensions	[49]	IMPLICIT SEQUENCE OF Extension OPTIONAL
	}

Message ::= [APPLICATION 17] SEQUENCE { 
	protocol-version-num	[0]	IMPLICIT INTEGER, -- {
				-- version-1 (1),
				-- version-2 (2)
				-- },
	transaction-id	[1]	IMPLICIT Transaction-Id,   
	service-date-time	[2]	IMPLICIT Service-Date-Time,
	requester-id	[3]	IMPLICIT System-Id OPTIONAL,   
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	responder-id	[4]	IMPLICIT System-Id OPTIONAL,   
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	note	[46]	ILL-String,
	message-extensions	[49]	IMPLICIT SEQUENCE OF Extension OPTIONAL
	}

Status-Query ::= [APPLICATION 18] SEQUENCE {
	protocol-version-num	[0]	IMPLICIT INTEGER, -- {
				-- version-1 (1),
				-- version-2 (2)
				-- },
	transaction-id	[1]	IMPLICIT Transaction-Id,
	service-date-time	[2]	IMPLICIT Service-Date-Time,
	requester-id	[3]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	responder-id	[4]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	note	[46]	ILL-String OPTIONAL,
	status-query-extensions	[49]	IMPLICIT SEQUENCE OF Extension OPTIONAL
	}

Status-Or-Error-Report ::= [APPLICATION 19] SEQUENCE {
	protocol-version-num	[0]	IMPLICIT INTEGER, -- {
				-- version-1 (1),
				-- version-2 (2)
				-- },
	transaction-id	[1]	IMPLICIT Transaction-Id,   
	service-date-time	[2]	IMPLICIT Service-Date-Time,
	requester-id	[3]	IMPLICIT System-Id OPTIONAL,   
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	responder-id	[4]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	reason-no-report	[43]	IMPLICIT Reason-No-Report OPTIONAL,
		-- mandatory if no report is present;
		-- not present otherwise
	status-report	[44]	IMPLICIT Status-Report OPTIONAL,
	error-report	[45]	IMPLICIT Error-Report OPTIONAL,
	note	[46]	ILL-String OPTIONAL,
	status-or-error-report-extensions	[49]	IMPLICIT SEQUENCE OF Extension OPTIONAL
	}

Expired ::= [APPLICATION 20] SEQUENCE {
	protocol-version-num	[0]	IMPLICIT INTEGER, -- {
				-- version-1 (1),
				--version-2 (2)
				-- },
	transaction-id	[1]	IMPLICIT Transaction-Id,
	service-date-time	[2]	IMPLICIT Service-Date-Time,
	requester-id	[3]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	responder-id	[4]	IMPLICIT System-Id OPTIONAL,
		-- mandatory when using store-and-forward communications
		-- optional when using connection-oriented communications
	expired-extensions	[49]	IMPLICIT SEQUENCE OF Extension OPTIONAL
	}

Account-Number ::= ILL-String

Already-Forwarded ::= EXPLICIT SEQUENCE {
	responder-id	[0]	IMPLICIT System-Id,
	responder-address	[1]	IMPLICIT System-Address OPTIONAL
	}	

Already-Tried-List-Type ::= SEQUENCE OF System-Id

Amount ::= SEQUENCE {
	currency-code	[0]	IMPLICIT PrintableString OPTIONAL, --(SIZE (3))
		-- values defined in ISO 4217-1981
	monetary-value	[1]	IMPLICIT AmountString -- (SIZE (1..10))
	}

AmountString ::= PrintableString -- (FROM ("1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"|"0"|" "|"."|","))

Client-Id ::= SEQUENCE {
	client-name	[0]	ILL-String OPTIONAL,
	client-status	[1]	ILL-String OPTIONAL,
	client-identifier	[2]	ILL-String OPTIONAL
	}

Conditional-Results ::= EXPLICIT SEQUENCE {
	conditions	[0]	IMPLICIT ENUMERATED {
				cost-exceeds-limit 				(13),
				charges 					(14),
				prepayment-required 			(15),
				lacks-copyright-compliance 			(16),
				library-use-only 				(22),
				no-reproduction 				(23),
				client-signature-required 			(24),
				special-collections-supervision-required	(25),
				other 					(27),
				responder-specific 				(28),
				proposed-delivery-service 			(30) 
				}
	date-for-reply	[1]	IMPLICIT ISO-Date OPTIONAL,
	locations	[2]	IMPLICIT SEQUENCE OF Location-Info OPTIONAL,
	proposed-delivery-service		Delivery-Service OPTIONAL
		-- this parameter specifies a proposed delivery service the
		-- acceptance of which is a condition of supply.  It may be a
		-- physical service or an electronic service.  This parameter
		-- may only be present in APDUs with a 
		-- protocol-version-num value of 2 or greater
	}

Cost-Info-Type ::= SEQUENCE {
	account-number	[0]	Account-Number OPTIONAL,
	maximum-cost	[1]	IMPLICIT Amount OPTIONAL,
	reciprocal-agreement	[2]	IMPLICIT BOOLEAN, -- DEFAULT FALSE,
	will-pay-fee	[3]	IMPLICIT BOOLEAN, -- DEFAULT FALSE,
	payment-provided	[4]	IMPLICIT BOOLEAN -- DEFAULT FALSE
	}

Current-State ::= ENUMERATED {
	nOT-SUPPLIED 	(1),
	pENDING	(2),
	iN-PROCESS	(3),
	fORWARD	(4),
	cONDITIONAL	(5),
	cANCEL-PENDING 	(6),
	cANCELLED	(7),
	sHIPPED 	(8),
	rECEIVED 	(9),
	rENEW-PENDING 	(10),
	nOT-RECEIVED-OVERDUE	(11),
	rENEW-OVERDUE 	(12),
	oVERDUE 	(13),
	rETURNED 	(14),
	cHECKED-IN	(15),
	rECALL 	(16),
	lOST 	(17),
	uNKNOWN 	(18)
	}

Damaged-Details ::= EXPLICIT SEQUENCE {
	document-type-id	[0]	IMPLICIT OBJECT IDENTIFIER OPTIONAL,
		-- identifies an OSI document type registered in accordance
		-- with ISO 9834-2, for use in an automated environment
	damaged-portion		CHOICE {
				complete-document	[1]	IMPLICIT NULL,
				specific-units	[2]	IMPLICIT SEQUENCE 
									OF INTEGER
				-- the nature and extent of a "unit" is implicit in the
				-- value of document-type-id if one is supplied
				}
	}

Date-Due ::= EXPLICIT SEQUENCE {
	date-due-field	[0]	IMPLICIT ISO-Date,
	renewable	[1]	IMPLICIT BOOLEAN -- DEFAULT TRUE
	}

Date-Time ::= SEQUENCE {
	date	[0]	IMPLICIT ISO-Date,
	time	[1]	IMPLICIT ISO-Time OPTIONAL
	}

Delivery-Address ::= SEQUENCE {
	postal-address	[0]	IMPLICIT Postal-Address OPTIONAL,
	electronic-address	[1]	IMPLICIT System-Address OPTIONAL
	}

Delivery-Service ::= CHOICE {
	physical-delivery	[7]	Transportation-Mode,
	electronic-delivery	[50]	IMPLICIT SEQUENCE OF Electronic-Delivery-Service
		-- electronic-delivery may only be present in APDUs
		-- with a protocol-version-num value of 2 or greater
	}

Document-Type ::= EXPLICIT SEQUENCE {
	document-type-id		[2] IMPLICIT OBJECT IDENTIFIER,
	-- identifies an OSI document type registered in accordance
	-- with ISO 9834-2
	document-type-parameters	[3] ANY DEFINED BY document-type-id
	-- any parameters relating to the registered document type
	}

E-Delivery-Service ::= EXPLICIT SEQUENCE {
	-- identifies the kind of electronic delivery service, e.g.
	-- MOTIS IPM,FTAM, etc., using the assigned object
	-- identifier for the standard e.g. {joint-iso-ccitt mhs-motis 
	-- ipms}
		e-delivery-mode	[0] IMPLICIT OBJECT IDENTIFIER,
		e-delivery-parameters	[1] ANY DEFINED BY e-delivery-mode
		} 

Electronic-Delivery-Service ::= EXPLICIT SEQUENCE {
	-- the first four parameters are intended to be used in an automated
	-- environment
		e-delivery-service	[0] IMPLICIT E-Delivery-Service OPTIONAL,
		document-type		[1] IMPLICIT Document-Type OPTIONAL,
		e-delivery-description		[4] ILL-String OPTIONAL,
		-- holds a human readable name or description of the
		-- required electronic delivery service and document type;
		-- this may also be used to identify an electronic delivery
		-- service for which there is no object identifier.
		-- This parameter may be present instead of, or in addition
		-- to, the previous 4 parameters
		e-delivery-details		[5] CHOICE {
			e-delivery-address	[0] IMPLICIT System-Address,
			e-delivery-id		[1] IMPLICIT System-Id
			}
		name-or-code		[6] ILL-String OPTIONAL,
		-- holds a human-readable identifier or correlation
		-- information for the document as shipped, e.g. a directory 
		-- and/or file name or message-id
		delivery-time		[7] IMPLICIT ISO-Time OPTIONAL
		-- holds the requester's preferred delivery time or
		-- the responder's proposed or actual delivery time
		}

Error-Report ::= EXPLICIT SEQUENCE {
	correlation-information	[0]	ILL-String,
	report-source	[1]	IMPLICIT Report-Source,
	user-error-report	[2]	User-Error-Report OPTIONAL,
		-- mandatory if report-source is "user"; not present otherwise
	provider-error-report	[3]	Provider-Error-Report OPTIONAL
		-- mandatory if report-source is "provider"; not
		-- present otherwise
	}

Estimate-Results ::= EXPLICIT SEQUENCE {
	cost-estimate	[0]	ILL-String,
	locations	[1]	IMPLICIT SEQUENCE OF Location-Info OPTIONAL
	}

Extension ::= SEQUENCE {
	--identifier	[0]	IMPLICIT INTEGER,
	identifier	[0]	OBJECT IDENTIFIER,
	critical	[1]	IMPLICIT BOOLEAN, -- DEFAULT FALSE,
	item		[2]	ANY DEFINED BY identifier
	--item		[2]	APDU-Delivery-Info
	}

General-Problem ::= ENUMERATED {
	unrecognized-APDU 	(1),
	mistyped-APDU 	(2),
	badly-structured-APDU 	(3),
	protocol-version-not-supported 	(4),
	other 	(5)
	}

History-Report ::= EXPLICIT SEQUENCE {
	date-requested	[0]	IMPLICIT ISO-Date OPTIONAL,
	author	[1]	ILL-String OPTIONAL,
	title	[2]	ILL-String OPTIONAL,
	author-of-article	[3]	ILL-String OPTIONAL,
	title-of-article	[4]	ILL-String OPTIONAL,
	date-of-last-transition 	[5]	IMPLICIT ISO-Date,
	most-recent-service	[6]	IMPLICIT ENUMERATED {
				iLL-REQUEST			(1),
				fORWARD 			(21),
				fORWARD-NOTIFICATION 		(2),
				sHIPPED 			(3),
				iLL-ANSWER 			(4),
				cONDITIONAL-REPLY 		(5),
				cANCEL 				(6),
				cANCEL-REPLY 			(7),
				rECEIVED 			(8),
				rECALL 				(9),
				rETURNED 			(10),
				cHECKED-IN 			(11),
				rENEW-ANSWER 			(14),
				lOST 				(15),
				dAMAGED 			(16),
				mESSAGE 			(17),
				sTATUS-QUERY 			(18),
				sTATUS-OR-ERROR-REPORT		(19),
				eXPIRED 			(20)
				}
	date-of-most-recent-service	[7]	IMPLICIT ISO-Date,
	initiator-of-most-recent-service	[8]	IMPLICIT System-Id,
	shipped-service-type	[9]	IMPLICIT Shipped-Service-Type OPTIONAL,
		-- If the information is available, i.e. if a SHIPPED or
		-- RECEIVED APDU has been sent or received, then the
		-- value in this parameter shall be supplied.
		-- Value must contain the most current information, e.g. if a
		-- requester has received a SHIPPED APDU and then
		-- invokes a RECEIVED.request, then the value from the
		-- RECEIVED.request is used
	transaction-results	[10]	IMPLICIT Transaction-Results OPTIONAL,
		-- If the information is available, i.e. if an ILL-ANWSER
		-- APDU has been sent or received, then the value in this
		-- parameter shall be supplied.
	most-recent-service-note	[11]	ILL-String OPTIONAL
		-- If the information is available, i.e. if a note has been
		-- supplied in the most recent service primitive, then the
		-- value in this parameter shall be supplied.
	}

Hold-Placed-Results ::= EXPLICIT SEQUENCE {
	estimated-date-available	[0]	IMPLICIT ISO-Date,
	hold-placed-medium-type	[1]	IMPLICIT Medium-Type OPTIONAL,
	locations	[2]	IMPLICIT SEQUENCE OF Location-Info OPTIONAL
	}

ILL-APDU-Type ::= ENUMERATED {
	iLL-REQUEST 	(1),
	fORWARD-NOTIFICATION 	(2),
	sHIPPED 	(3),
	iLL-ANSWER 	(4),
	cONDITIONAL-REPLY 	(5),
	cANCEL 	(6),
	cANCEL-REPLY 	(7),
	rECEIVED 	(8),
	rECALL 	(9),
	rETURNED 	(10),
	cHECKED-IN 	(11),
	oVERDUE 	(12),
	rENEW 	(13),
	rENEW-ANSWER 	(14),
	lOST 	(15),
	dAMAGED 	(16),
	mESSAGE 	(17),
	sTATUS-QUERY 	(18),
	sTATUS-OR-ERROR-REPORT	(19),
	eXPIRED 	(20)
	}

ILL-Service-Type ::= ENUMERATED  {
	loan 	(1),
	copy-non-returnable 	(2),
	locations 	(3),
	estimate 	(4),
	responder-specific 	(5)
	}

ILL-String ::= CHOICE {
	generalstring	GeneralString,
	-- may contain any ISO registered G (graphic) and C
	-- (control) character set
	edifactstring	EDIFACTString
	}
	-- may not include leading or trailing spaces
	-- may not consist only of space (" ") or non-printing 
	-- characters

Intermediary-Problem ::= ENUMERATED {
	cannot-send-onward 	(1)
	}

ISO-Date ::= VisibleString
	-- conforms to ISO 8601
	-- length = 8
	-- fixed
	-- YYYYMMDD

ISO-Time ::= VisibleString
	-- conforms to ISO 8601
	-- length = 6, 
	-- fixed
	-- HHMMSS
	-- local time of person or institution invoking service

Item-Id ::= SEQUENCE {
	item-type	[0]	IMPLICIT Item-Type OPTIONAL,
	held-medium-type	[1]	IMPLICIT Medium-Type OPTIONAL,
	call-number	[2]	ILL-String OPTIONAL,
	author	[3]	ILL-String OPTIONAL,
	title	[4]	ILL-String OPTIONAL,
	sub-title	[5]	ILL-String OPTIONAL,
	sponsoring-body	[6]	ILL-String OPTIONAL,
	place-of-publication 	[7]	ILL-String OPTIONAL,
	publisher	[8]	ILL-String OPTIONAL,
	series-title-number 	[9]	ILL-String OPTIONAL,
	volume-issue	[10]	ILL-String OPTIONAL,
	edition	[11]	ILL-String OPTIONAL,
	publication-date	[12]	ILL-String OPTIONAL,
	publication-date-of-component	[13] ILL-String OPTIONAL,
	author-of-article	[14]	ILL-String OPTIONAL,
	title-of-article	[15]	ILL-String OPTIONAL,
	pagination	[16]	ILL-String OPTIONAL,
-- DC - 'EXTERNAL' is not supported in Convert::ASN1
--	national-bibliography-no	[17]	EXTERNAL OPTIONAL,
	iSBN	[18]	ILL-String OPTIONAL, -- (SIZE (10))
		-- must conform to ISO 2108-1978
	iSSN	[19]	ILL-String OPTIONAL, -- (SIZE (8))
		-- must conform to ISO 3297-1986
-- DC - 'EXTERNAL' is not supported in Convert::ASN1
--	system-no	[20]	EXTERNAL OPTIONAL,
	additional-no-letters	[21] ILL-String OPTIONAL,
	verification-reference-source	[22] ILL-String OPTIONAL
	}

Item-Type ::= ENUMERATED {
		monograph	(1),
		serial 	(2),
		other	(3)
		}

Location-Info ::= EXPLICIT SEQUENCE {
	location-id	[0]	IMPLICIT System-Id,
	location-address	[1]	IMPLICIT System-Address OPTIONAL,
	location-note	[2]	ILL-String OPTIONAL
	}

Locations-Results ::= EXPLICIT SEQUENCE {
	reason-locs-provided	[0]	IMPLICIT Reason-Locs-Provided OPTIONAL,
	locations	[1]	IMPLICIT SEQUENCE OF Location-Info
	}

Medium-Type ::= ENUMERATED {
	printed 	(1),
	microform 	(3),
	film-or-video-recording	(4),
	audio-recording 	(5),
	machine-readable 	(6),
	other 	(7)
	}

Name-Of-Person-Or-Institution ::= CHOICE {
	name-of-person	[0]	ILL-String,
	name-of-institution	[1]	ILL-String
	}

Person-Or-Institution-Symbol ::= CHOICE {
	person-symbol	[0]	ILL-String,
	institution-symbol	[1]	ILL-String
	}

Place-On-Hold-Type ::= ENUMERATED {
	yes 	(1),
	no 	(2),
	according-to-responder-policy	(3)
	}

Postal-Address ::= SEQUENCE {
	name-of-person-or-institution	[0]	Name-Of-Person-Or-Institution OPTIONAL,
	extended-postal-delivery-address [1]	ILL-String OPTIONAL,
	street-and-number	[2]	ILL-String OPTIONAL,
	post-office-box	[3]	ILL-String OPTIONAL,
	city	[4]	ILL-String OPTIONAL,
	region	[5]	ILL-String OPTIONAL,
	country	[6]	ILL-String OPTIONAL,
	postal-code	[7]	ILL-String OPTIONAL
	}

Provider-Error-Report ::= CHOICE {
	general-problem	[0]	IMPLICIT General-Problem,
	transaction-id-problem 	[1]	IMPLICIT Transaction-Id-Problem,
	state-transition-prohibited	[2]	IMPLICIT State-Transition-Prohibited
	}

Reason-Locs-Provided ::= ENUMERATED {
	in-use-on-loan 	(1),
	in-process 	(2),
	lost 	(3),
	non-circulating 	(4),
	not-owned 	(5),
	on-order 	(6),
	volume-issue-not-yet-available 	(7),
	at-bindery 	(8),
	lacking 	(9),
	not-on-shelf 	(10),
	on-reserve 	(11),
	poor-condition 	(12),
	cost-exceeds-limit 	(13),
	on-hold 	(19),
	other 	(27),
	responder-specific 	(28) 
	}

Reason-No-Report ::= ENUMERATED {
	temporary	(1),
	permanent	(2)
	}

Reason-Not-Available ::= ENUMERATED {
	in-use-on-loan 			(1),
	in-process 				(2),
	on-order 				(6),
	volume-issue-not-yet-available	(7),
	at-bindery 				(8),
	cost-exceeds-limit 			(13),
	charges 				(14),
	prepayment-required 		(15),
	lacks-copyright-compliance		(16),
	not-found-as-cited 			(17),
	on-hold 				(19),
	other 				(27),
	responder-specific 			(28)
	}

Reason-Unfilled ::= ENUMERATED {
	in-use-on-loan	(1),
	in-process	(2),
	lost	(3),
	non-circulating	(4),
	not-owned	(5),
	on-order	(6),
	volume-issue-not-yet-available	(7),
	at-bindery	(8),
	lacking	(9),
	not-on-shelf 	(10),
	on-reserve	(11),
	poor-condition	(12),
	cost-exceeds-limit	(13),
	charges	(14),
	prepayment-required	(15),
	lacks-copyright-compliance	(16),
	not-found-as-cited	(17),
	locations-not-found	(18),
	on-hold	(19),
	policy-problem	(20),
	mandatory-messaging-not-supported	(21),
	expiry-not-supported	(22) ,
	requested-delivery-services-not-supported	(23),
 	preferred-delivery-time-not-possible	(24),
	other	(27),
	responder-specific	(28)
	}

Reason-Will-Supply ::= ENUMERATED {
	in-use-on-loan 			(1),
	in-process 			(2),
	on-order 			(6),
	at-bindery 			(8),
	on-hold 			(19),
	being-processed-for-supply 	(26),
	other 				(27),
	responder-specific 		(28),
	electronic-delivery 		(30)
	}

Report-Source ::= ENUMERATED {
	user	(1),
	provider	(2)
	}

Requester-Optional-Messages-Type ::= SEQUENCE {
	can-send-RECEIVED	[0]	IMPLICIT BOOLEAN,
	can-send-RETURNED	[1]	IMPLICIT BOOLEAN,
	requester-SHIPPED	[2]	IMPLICIT ENUMERATED {
				requires	(1),
				desires 	(2),
				neither	(3)
				}
	requester-CHECKED-IN	[3]	IMPLICIT ENUMERATED {
				requires 	(1),
				desires 	(2),
				neither 	(3)
				}
	}

Responder-Optional-Messages-Type ::= EXPLICIT SEQUENCE {
	can-send-SHIPPED	[0]	IMPLICIT BOOLEAN,
	can-send-CHECKED-IN	[1]	IMPLICIT BOOLEAN,
	responder-RECEIVED	[2]	IMPLICIT ENUMERATED {
				requires 	(1),
				desires 	(2),
				neither 	(3)
				}
	responder-RETURNED	[3]	IMPLICIT ENUMERATED {
				requires 	(1),
				desires 	(2),
				neither 	(3)
				}
	}

Results-Explanation ::= CHOICE {
				conditional-results	[1] Conditional-Results,
				-- chosen if transaction-results=CONDITIONAL
				retry-results		[2] Retry-Results,
				-- chosen if transaction-results=RETRY
				unfilled-results	[3] Unfilled-Results,
				--chosen if transaction-results=UNFILLED
				locations-results	[4] Locations-Results,
				-- chosen if transaction-results=LOCATIONS-PROVIDED
	 			will-supply-results	[5] Will-Supply-Results,
				-- chosen if transaction-results=WILL-SUPPLY
				hold-placed-results	[6] Hold-Placed-Results,
				-- chosen if transaction-results=HOLD-PLACED
				estimate-results	[7] Estimate-Results
				-- chosen if transaction-results=ESTIMATE
				}

Retry-Results ::= EXPLICIT SEQUENCE {
	reason-not-available	[0]	IMPLICIT Reason-Not-Available OPTIONAL,
	retry-date	[1]	IMPLICIT ISO-Date OPTIONAL,
	locations	[2]	IMPLICIT SEQUENCE OF Location-Info OPTIONAL
	}

Search-Type ::= SEQUENCE {
	level-of-service	[0]	ILL-String OPTIONAL, -- (SIZE (1))
	need-before-date	[1]	IMPLICIT ISO-Date OPTIONAL,
	expiry-flag	[2]	IMPLICIT ENUMERATED {
				need-Before-Date	(1),
				other-Date 		(2),
				no-Expiry 		(3)
				} -- DEFAULT 3,
				-- value of "need-Before-Date" indicates that
				-- need-before-date also specifies transaction expiry
				-- date
	expiry-date	[3]	IMPLICIT ISO-Date OPTIONAL
		-- alternative expiry date can be used only when expiry-flag
		-- is set to "Other-Date"
	}

Security-Problem ::= ILL-String

Send-To-List-Type ::= SEQUENCE OF SEQUENCE {
	system-id	[0]	IMPLICIT System-Id,
	account-number	[1]	Account-Number OPTIONAL,
	system-address	[2]	IMPLICIT System-Address OPTIONAL
	}

Service-Date-Time ::= SEQUENCE {
	date-time-of-this-service 	[0]	IMPLICIT Date-Time,
	-- Time is mandatory for 2nd and subsequent services
	-- invoked for a given ILL-transaction on the same day
	date-time-of-original-service	[1]	IMPLICIT Date-Time OPTIONAL
	}

Shipped-Conditions ::= ENUMERATED {
	library-use-only				(22),
	no-reproduction				(23),
	client-signature-required			(24),
	special-collections-supervision-required	(25),
	other					(27)
	}

Shipped-Service-Type ::= ILL-Service-Type -- (loan | copy-non-returnable)
	-- subtype of ILL-Service-Type

Shipped-Via ::= CHOICE {
	physical-delivery	[5]	Transportation-Mode,
	electronic-delivery	[50]	IMPLICIT Electronic-Delivery-Service
	}

State-Transition-Prohibited ::= EXPLICIT SEQUENCE {
	aPDU-type	[0]	IMPLICIT ILL-APDU-Type,
	current-state	[1]	IMPLICIT Current-State
	}

Status-Report ::= EXPLICIT SEQUENCE {
	user-status-report	[0]	IMPLICIT History-Report,
	provider-status-report 	[1]	IMPLICIT Current-State
	}

-- DC - 'EXTERNAL' is not supported in Convert::ASN1
-- Supplemental-Item-Description ::= EXPLICIT SEQUENCE OF EXTERNAL
--	-- the syntax of supplementary item description information is defined outside this standard

Supply-Details ::= EXPLICIT SEQUENCE {
	date-shipped	[0]	IMPLICIT ISO-Date OPTIONAL,
	date-due	[1]	IMPLICIT Date-Due OPTIONAL,
	chargeable-units	[2]	IMPLICIT INTEGER OPTIONAL, -- (1..9999)
	cost	[3]	IMPLICIT Amount OPTIONAL,
	shipped-conditions	[4]	IMPLICIT Shipped-Conditions OPTIONAL,
	shipped-via		Shipped-Via OPTIONAL,
		-- electronic-delivery may only be present in APDUs with a
		-- protocol-version-num value of 2 or greater
	insured-for	[6]	IMPLICIT Amount OPTIONAL,
	return-insurance-require	[7]	IMPLICIT Amount OPTIONAL,
	no-of-units-per-medium	[8]	IMPLICIT SEQUENCE OF Units-Per-Medium-Type OPTIONAL
	}

Supply-Medium-Info-Type ::= EXPLICIT SEQUENCE {
	supply-medium-type  	[0]	IMPLICIT Supply-Medium-Type,
	medium-characteristics 	[1]	ILL-String OPTIONAL
	}

Supply-Medium-Type ::= ENUMERATED {
	printed	(1),
	photocopy	(2),
	microform	(3),
	film-or-video-recording	(4),
	audio-recording	(5),
	machine-readable	(6),
	other	(7)
	}

System-Address ::= SEQUENCE {
	telecom-service-identifier	[0]	ILL-String OPTIONAL,
	telecom-service-address	[1]	ILL-String OPTIONAL
	}

System-Id ::= SEQUENCE {
	--at least one of the following must be present
	person-or-institution-symbol	[0]	Person-Or-Institution-Symbol OPTIONAL,
	name-of-person-or-institution	[1]	Name-Of-Person-Or-Institution OPTIONAL
	}

Third-Party-Info-Type ::= SEQUENCE {
	permission-to-forward	[0]	IMPLICIT BOOLEAN, -- DEFAULT FALSE,
	permission-to-chain	[1]	IMPLICIT BOOLEAN, -- DEFAULT FALSE,
	permission-to-partition 	[2]	IMPLICIT BOOLEAN, -- DEFAULT FALSE,
	permission-to-change-send-to-list [3]	IMPLICIT BOOLEAN, -- DEFAULT FALSE,
	initial-requester-address 	[4]	IMPLICIT System-Address OPTIONAL,
		-- mandatory when initiating a FORWARD service or an
		-- ILL-REQUEST service for a partitioned ILL
		-- sub-transaction; optional otherwise
	preference	[5]	IMPLICIT ENUMERATED {
				ordered	(1),
				unordered	(2)
				} -- DEFAULT 2,
	send-to-list	[6]	IMPLICIT Send-To-List-Type OPTIONAL,
	already-tried-list	[7]	IMPLICIT Already-Tried-List-Type OPTIONAL
		-- mandatory when initiating a FORWARD service, or when
		-- initiating an ILL-REQUEST service for an ILL
		-- sub-transaction if the received ILL-REQUEST included an
		-- "already-tried-list"; optional otherwise
	}

Transaction-Id ::= SEQUENCE {
	initial-requester-id	[0]	IMPLICIT System-Id OPTIONAL,
		-- mandatory for sub-transactions; not called
		-- "requester-id" to distinguish id of initial-requester
		--from id of requester of sub-transaction if there is one
	transaction-group-qualifier	[1]	ILL-String,
	transaction-qualifier	[2]	ILL-String,
	sub-transaction-qualifier	[3]	ILL-String OPTIONAL
		-- mandatory for sub-transactions
	}

Transaction-Id-Problem ::= ENUMERATED {
	duplicate-transaction-id	(1),
	invalid-transaction-id	(2),
	unknown-transaction-id	(3)
	}

Transaction-Results ::= ENUMERATED {
	conditional	(1),
	retry	(2),
	unfilled	(3),
	locations-provided	(4),
	will-supply	(5),
	hold-placed	(6),
	estimate	(7)
	}

Transaction-Type ::= ENUMERATED  {
	simple	(1),
	chained	(2),
	partitioned	(3)
	}

Transportation-Mode ::= ILL-String

Unable-To-Perform ::= ENUMERATED {
	not-available	(1),
	resource-limitation 	(2),
	other 	(3)
	}

Unfilled-Results ::= EXPLICIT SEQUENCE {
	reason-unfilled	[0]	IMPLICIT Reason-Unfilled,
	locations	[1]	IMPLICIT SEQUENCE OF Location-Info OPTIONAL
	}

Units-Per-Medium-Type ::= EXPLICIT SEQUENCE {
	medium	[0]	Supply-Medium-Type,
	no-of-units	[1]	INTEGER -- (1..9999)
	}

User-Error-Report ::= CHOICE {
	already-forwarded	[0]	IMPLICIT Already-Forwarded,
	intermediary-problem	[1]	IMPLICIT Intermediary-Problem,
	security-problem	[2]	Security-Problem,
	unable-to-perform	[3]	IMPLICIT Unable-To-Perform
	}


Will-Supply-Results ::= EXPLICIT SEQUENCE {
	reason-will-supply 	[0]	Reason-Will-Supply,
	supply-date	[1]	ISO-Date OPTIONAL,
	return-to-address	[2]	Postal-Address OPTIONAL,
	locations	[3]	IMPLICIT SEQUENCE OF Location-Info OPTIONAL,
	electronic-delivery-service	[4] Electronic-Delivery-Service OPTIONAL
		-- if present, this must be one of the services proposed by 
		-- the requester
	}

EDIFACTString ::= VisibleString 
	-- (FROM ("A"|"B"|"C"|"D"|"E"|"F"|"G"|"H"|
	-- "I"|"J"|"K"|"L"|"M"|"N"|"O"|"P"|"Q"|"R"|"S"|"T"|"U"|
	-- "V"|"W"|"X"|"Y"|"Z"|"a"|"b"|"c"|"d"|"e"|"f"|"g"|"h"|
	-- "i"|"j"|"k"|"l"|"m"|"n"|"o"|"p"|"q"|"r"|"s"|"t"|"u"|
	-- "v"|"w"|"x"|"y"|"z"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|
	-- "9"|"0"|" "|"."|","|"-"|"("|")"|"/"|"="|"!"|"""|"%"|"&"|
	-- "*"|";"|"<"|">"|"'"|"+"|":"|"?"))

-- END  '<-- balance the quote from EDIFACTString (just to make emacs happy)


-- DC expiriment
----ILL-APDU-Delivery-Info DEFINITIONS  ::= 
---- the object identifier for this extension, registered with
---- the Interlibrary Loan Application Standards Maintenance
---- Agency, is 1.0.10161.13.3
--
----BEGIN
--
----IMPORTS System-Address, System-Id from ISO-10161-ILL-1;
--
--APDU-Delivery-Info::=SEQUENCE {
--	sender-info           [0] IMPLICIT SEQUENCE OF APDU-Delivery-Parameters,
--        recipient-info        [1] IMPLICIT SEQUENCE OF APDU-Delivery-Parameters,
--        transponder-info      [2] IMPLICIT SEQUENCE OF APDU-Delivery-Parameters OPTIONAL
--        }
--
--APDU-Delivery-Parameters::=SEQUENCE {
--        encoding        [0] IMPLICIT SEQUENCE OF APDU-Encoding,  -- SIZE (1..3) 
--                            --provides, in preferred order, the types
--                            --of encoding acceptable at the address
--                            --indicated in transport
--        transport       [1] IMPLICIT System-Address,
--        aliases         [2] IMPLICIT SEQUENCE OF System-Id OPTIONAL
--                            --provides in unsorted order, the several
--                            --System-Ids associated with this
--                            --System-Address
--        }
--
--APDU-Encoding::=ENUMERATED {
--        eDIFACT         (1),
--        bER-IN-MIME     (2),
--        bER             (3)
--        }
--
--
--
----END
_END_OF_ASN_

=head1 SEE ALSO

See the README for system design notes.
See the parent class(es) for other available methods.

For more information on Interlibrary Loan standards (ISO 10160/10161),
a good place to start is:

http://www.nlc-bnc.ca/iso/ill/main.htm

=cut

=head1 AUTHOR

David Christensen, <DChristensenSPAMLESS@westman.wave.ca>

=cut


=head1 COPYRIGHT AND LICENSE

Copyright 2003 by David Christensen

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
