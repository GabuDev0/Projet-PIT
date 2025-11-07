# Si le fichier à supprimer n'existe plus dans le répertoire du jeu
if [[ ! -f $( < "./var/cache/tmp/evil_file.solution") ]]; then
    clear
    echo "Vous avez arrêté ECHO !!! Le département est sauvé !!!!!"

else
    echo "Le fichier est toujours là..."
fi