/*

TODO: MAKE THE AUTHENTICATION WORK FFS
TODO: add method to calculate user points for a task (so they won t be introduced by the user)
TODO: 


? move tasks around manually in the list
? ask a user if they wan t ot delete a todo after they completed the task
?

*  add google authentication dar dupa ce am terminat cu todo urile
*  add forget password in the log in field
* add complete : bool la un task ( can be useful with the crossing thing or with moving it at the end of the list)

! check what are collection groups in firestore


1. There is a UUID pub package:

http://pub.dartlang.org/packages/uuid

example usage:

import 'package:uuid/uuid.dart';

 Create uuid object
var uuid = Uuid();

 Generate a v1 (time-based) id
uuid.v1(); // -> '6c84fb90-12c4-11e1-840d-7b25c5ee775a'

 Generate a v4 (random) id
uuid.v4(); // -> '110ec58a-a0f2-4ac4-8393-c866d813b8d1'

 Generate a v5 (namespace-name-sha1-based) id
uuid.v5(uuid.NAMESPACE_URL, 'www.google.com'); // -> 'c74a196f-f19d-5ea9-bffd-a2742432fc9c
*/