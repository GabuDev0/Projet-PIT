Dans ce jeu, vous incarnez un agent d'une organisation gouvernementale secrète qui combat une entité appelée ECHO qui utilise une IA surpuissante pour commettre des actes terroristes. Votre but ? Découvrir leur prochain but et les empêcher de nuire.

Le jeu se compose de 8 scripts. 6 seront utilisables par le joueur.

** Déroulement d'une partie:


Lancez ./start.sh pour créer tous les dossiers nécessaires au jeu
Puis lancez ./start.sh 0 pour commencer le jeu


Des logs de connexion vont apparaitre à l'écran. Ils sont aussi visibles dans le fichier ./var/log/network.log
Les seules lignes utiles sont les acquittements contenant une clé d'authentification. Il faut tester chacun de ces doublets ip/clé avec le script ./ping.sh \[ip] \[clé]

Si l'ip n'est pas bonne, le ping ne recevra aucune réponse. Si l'ip est bonne mais que la clé n'est pas la bonne, la connexion sera coupée de force et une erreur d'autorisation sera envoyée. Si les deux sont correctes, l'adresse ip du destinataire enverra des ECHO reply.
Dans ce dernier cas, le joueur doit donc créer deux fichiers key et ip dans le dossier ./var/cache/tmp/, contenant respectivement la clé d'authentification et l'adresse ip. Le joueur pourra ensuite établir une connexion TCP avec le destinataire mystérieux d'ECHO en se faisant passer pour eux, et récupérer les fichiers qu'ils se sont échangés.

Le joueur devra ensuite cracker le fichier .secret pour découvrir leur plan et trouver quel script bash supprimer avant que leur plan n'arrive à exécution. Pour cela, il devra observer les patterns des clés de chiffrement échangés entre ECHO et le "destinataire mystérieux". Il devra ensuite créer un script qui exécute le script fourni decode.sh pour toutes les possibilités répondant aux règles repérées lors de la connexion.

Finalement, le joueur doit supprimer un des trois fichiers générés après l'exécution de connect.sh, et gagne s'il a supprimé le bon.
**

CHEAT CODE: les différentes données nécessaires à certains moments du jeux sont cachées dans le dossier ./var/cache/tmp sous l'extension .solution