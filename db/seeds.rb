User.create!([
  {email: "tom@tom.com", password: "tomtom", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 1, current_sign_in_at: "2017-09-20 16:32:39", last_sign_in_at: "2017-09-20 16:32:39", current_sign_in_ip: "46.53.177.123", last_sign_in_ip: "46.53.177.123", confirmation_token: "nmuVGK1_eWvH5jh8S5zv", confirmed_at: "2017-09-20 17:01:11", confirmation_sent_at: "2017-09-20 16:30:03", unconfirmed_email: nil, name: "Tom Cat", developer_role: false, manager_role: true},
  {email: "jerry@jerry.com", password: "jerryjerry", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 1, current_sign_in_at: "2017-09-20 17:01:23", last_sign_in_at: "2017-09-20 17:01:23", current_sign_in_ip: "46.53.177.123", last_sign_in_ip: "46.53.177.123", confirmation_token: "YwgqtA4NkzxUu4Gfctbo", confirmed_at: "2017-09-20 17:01:11", confirmation_sent_at: "2017-09-20 16:29:46", unconfirmed_email: nil, name: "Jerry Mouse", developer_role: true, manager_role: false},
  {email: "spike@spike.com", password: "spikespike", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 1, current_sign_in_at: "2017-09-20 17:08:10", last_sign_in_at: "2017-09-20 17:08:10", current_sign_in_ip: "46.53.177.123", last_sign_in_ip: "46.53.177.123", confirmation_token: "hSPBayK_HQmx1yp-sfuP", confirmed_at: "2017-09-20 17:01:11", confirmation_sent_at: "2017-09-20 16:30:21", unconfirmed_email: nil, name: "Spike Dog", developer_role: true, manager_role: false},
  {email: "quacker@quacker.com", password: "quackerquacker", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 1, current_sign_in_at: "2017-09-20 17:13:55", last_sign_in_at: "2017-09-20 17:13:55", current_sign_in_ip: "46.53.177.123", last_sign_in_ip: "46.53.177.123", confirmation_token: "vWyMWzyFUpHkxy8Byqr6", confirmed_at: "2017-09-20 17:01:11", confirmation_sent_at: "2017-09-20 16:30:36", unconfirmed_email: nil, name: "Quacker Duck", developer_role: true, manager_role: false},
  {email: "tyke@tyke.com", password: "tyketyke", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 1, current_sign_in_at: "2017-09-20 17:16:09", last_sign_in_at: "2017-09-20 17:16:09", current_sign_in_ip: "46.53.177.123", last_sign_in_ip: "46.53.177.123", confirmation_token: "Rwsg7YG1Ys_xfv_zEdw7", confirmed_at: "2017-09-20 17:01:11", confirmation_sent_at: "2017-09-20 17:00:53", unconfirmed_email: nil, name: "Tyke Doggy", developer_role: false, manager_role: true}
])
Project.create!([
  {title: "Being a good kitty", description: "I should be a good kitty for my mistress, and make this stupid mouse go away! Spike Dog will help me... I hope he won't eat me afterwards...", user_id: 1},
  {title: "Quacker Duck birthday", description: "Let's celebrate, my friends! (I promise not to eat you guys, honest.)", user_id: 1},
  {title: "Empty project", description: "Totally desolated.", user_id: 1},
  {title: "A lonely project of mine", description: "Maybe Quacker Duck will join me in my misery...", user_id: 5}
])
Task.create!([
  {title: "Catch the mouse!", description: "WE GOTA DO IT, SPIKE", status: "implementation", user_id: 3, project_id: 1},
  {title: "Bake the cake", description: "Y'know what to do, we need a really good cake this year!", status: "implementation", user_id: 2, project_id: 2},
  {title: "Pump up the balloons", description: "We need a total of 10 balloons for the party.", status: "waiting", user_id: 3, project_id: 2},
  {title: "Empty task", description: "With nothing to do and no developer assigned", status: "waiting", user_id: nil, project_id: 2},
  {title: "Be miserable", description: "Till the end of the world.", status: "releasing", user_id: nil, project_id: 4}
])
Comment.create!([
  {body: "What's the plan, Spike?? Think we should just chase him (is Jerry even a he?) down??", task_id: 1, user_id: 1},
  {body: "Jerry, you do it, and I'll check that you won't mess anything up!", task_id: 2, user_id: 1},
  {body: "PUMP IT BABY", task_id: 3, user_id: 1},
  {body: "Omg, Tom, you're a joke. I'll handle it.", task_id: 2, user_id: 2},
  {body: "HEL YEA MEN LETZ DU IT", task_id: 1, user_id: 3},
  {body: "Wooohooo, ballooons, I love 'em!", task_id: 3, user_id: 4},
  {body: "You guys are so cute <3", task_id: 3, user_id: 4},
  {body: "T_T", task_id: 5, user_id: 5}
])

Project.find_by_id(1).update!("user_ids"=>["3"])
Project.find_by_id(2).update!("user_ids"=>["2", "3", "4"])
Project.find_by_id(4).update!("user_ids"=>["4"])
