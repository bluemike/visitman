Rails.application.routes.draw do

  resources :users
  get 'users', to: 'users#index'

  resources :teams
  get 'teams', to: 'teams#index'

  resources :students
  get 'students', to: 'students#index'

  get 'student_import', to: 'student_import#index'
  get 'student_import/show', to: 'student_import#show'
  post 'student_import/student_import', to: 'student_import#student_import'
  delete 'student_import/delete_all_students', to: 'student_import#delete_all_students'
  delete 'student_import/delete_all_students', to: 'student_import#delete_all_students'

  get 'student_export', to: 'student_export#index'
  post 'student_export/student_export', to: 'student_export#student_export'

  resources :teachers
  get 'teachers', to: 'teachers#index'

  get 'teacher_import', to: 'teacher_import#index'
  get 'teacher_import/show', to: 'teacher_import#show'
  post 'teacher_import/teacher_import', to: 'teacher_import#teacher_import'
  delete 'teacher_import/delete_all_teachers', to: 'teacher_import#delete_all_teachers'
  delete 'teacher_import/delete_all_teachers', to: 'teacher_import#delete_all_teachers'

  get 'teacher_export', to: 'teacher_export#index'
  post 'teacher_export/teacher_export', to: 'teacher_export#teacher_export'

  get 'teacherteam_import', to: 'teacherteam_import#index'
  get 'teacherteam_import/show', to: 'teacherteam_import#show'
  post 'teacherteam_import/teacherteam_import', to: 'teacherteam_import#teacherteam_import'
  delete 'teacherteam_import/delete_all_teacherteams', to: 'teacherteam_import#delete_all_teacherteams'
  delete 'teacherteam_import/delete_all_teacherteams', to: 'teacherteam_import#delete_all_teacherteams'

  resources :events
  get 'events', to: 'events#index'

  resources :rooms
  get 'rooms', to: 'rooms#index'

  get 'slots', to: 'slots#index'
  get 'slots/show', to: 'slots#show'
  post 'slots/create_slot_group', to: 'slots#create_slot_group'
  delete 'slots/delete_all_slots', to: 'slots#delete_all_slots'
  post 'slots/slot_date_changed', to: 'slots#slot_date_changed'

  root to: 'cockpit#index'
  get 'cockpit', to: 'cockpit#index', as: :cockpit
  get 'cockpit/view_availabilities', to: 'cockpit#view_availabilities'
  post 'cockpit/view_availabilities_slot_date_changed', to: 'cockpit#view_availabilities_slot_date_changed'
  get 'cockpit/view_reservations', to: 'cockpit#view_reservations'
  post 'cockpit/view_reservations_slot_date_changed', to: 'cockpit#view_reservations_slot_date_changed'
  get 'cockpit/view_teacher_reservations', to: 'cockpit#view_teacher_reservations'
  post 'cockpit/view_teacher_reservations_input_changed', to: 'cockpit#view_teacher_reservations_input_changed'
  get 'cockpit/select_student_reservations', to: 'cockpit#select_student_reservations'
  post 'cockpit/select_student_reservations', to: 'cockpit#select_student_reservations'
  get 'cockpit/view_student_reservations/:student_id', to: 'cockpit#view_student_reservations'
  get 'cockpit/view_student_reservations', to: 'cockpit#view_student_reservations'
  post 'cockpit/view_student_reservations_slot_date_changed', to: 'cockpit#view_student_reservations_slot_date_changed'
  get 'cockpit/view_teacher_room_reservations', to: 'cockpit#view_teacher_room_reservations'
  post 'cockpit/view_teacher_room_reservations_slot_date_changed', to: 'cockpit#view_teacher_room_reservations_slot_date_changed'
  get 'cockpit/print_teacher_reservations', to: 'cockpit#print_teacher_reservations'

  get 'login', to: 'login#login'
  post 'login/login', to: 'login#login'
  get 'logout', to: 'login#logout', as: :logout

  get 'teachman', to: 'teachman#login'
  get 'teachman/login', to: 'teachman#login'
  post 'teachman/login', to: 'teachman#login'
  get 'teachman/logout', to: 'teachman#logout'
  get 'teachman/overview', to: 'teachman#overview'
  get 'teachman/manage_availability', to: 'teachman#manage_availability'
  post 'teachman/manage_availability_slot_date_changed', to: 'teachman#manage_availability_slot_date_changed'
  get 'teachman/manage_availability_availability_changed', to: 'teachman#manage_availability_availability_changed'
  post 'teachman/manage_availability_availability_changed', to: 'teachman#manage_availability_availability_changed'
  get 'teachman/view_reservations', to: 'teachman#view_reservations'
  post 'teachman/view_reservations_slot_date_changed', to: 'teachman#view_reservations_slot_date_changed'
  get 'teachman/view_teamteachers', to: 'teachman#view_teamteachers'
  get 'teachman/view_teamstudents', to: 'teachman#view_teamstudents'

  get 'studman', to: 'studman#login'
  get 'studman/login', to: 'studman#login'
  post 'studman/login', to: 'studman#login'
  get 'studman/logout', to: 'studman#logout'
  get 'studman/overview', to: 'studman#overview'
  get 'studman/manage_reservations', to: 'studman#manage_reservations'
  post 'studman/manage_reservations_slot_date_changed', to: 'studman#manage_reservations_slot_date_changed'
  get 'studman/manage_reservations_reservation_book', to: 'studman#manage_reservations_reservation_book'
  get 'studman/manage_reservations_reservation_cancel', to: 'studman#manage_reservations_reservation_cancel'
  get 'studman/view_reservations', to: 'studman#view_reservations'
  post 'studman/view_reservations_slot_date_changed', to: 'studman#view_reservations_slot_date_changed'

  get 'reservation_simulator', to: 'reservation_simulator#index'
  get 'reservation_simulator/index', to: 'reservation_simulator#index'
  post 'reservation_simulator/execute', to: 'reservation_simulator#execute'

end
