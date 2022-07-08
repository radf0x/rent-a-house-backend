prod_first_deploy:
	git push -f heroku master
	heroku run rails db:migrate
	heroku run rails db:seed
	heroku run rails rental:setup_db:from_local

prod_deploy:
	git push -f heroku master
	heroku run rails db:migrate

prod_console:
	heroku run rails c -a rent-a-house-backend

prod_migrate_db:
	heroku run rails db:migrate

prod_setup_db:
	heroku run rails db:seed
	heroku run rails rental:setup_db:from_local

setup_property_table_with_local_data:
	heroku run rails rental:setup_db:from_local

setup_property_table_with_remote_data:
	heroku run rails rental:setup_db:from_remote
