Rails.application.routes.draw do                
  match '/',                               to: 'menus#index',                                       via: 'get'  
  match 'about/',                          to: 'menus#index',                                       via: 'get'          
  
    
  match 'about/:translit',                 to: 'orders#a_new_order',                                via: 'get'  
  post  '/orders',                         to: 'orders#create'                     # for OrderForm works (path for creating new order)
  match '/click_for_pay',                  to: 'pays#b_page_for_select_pay_way',                    via: 'get'
  
  #match '/i_have_payed/:name/:akey/:id',   to: 'orders#c_form_for_get_consult_after_pay',           via: 'get'    
  match '/i_have_payed',   to: 'orders#c_form_for_get_consult_after_pay',           via: 'get'      
  patch '/save_pay_info/:id',              to: 'orders#update',                                     via: 'get'                
  match '/request_sent/:id',               to: 'orders#d_pay_info_success_sent',                    via: 'get'    
  
  match '/payed/:akey/:id/:akey_payed',    to: 'orders#change_status_to_payed',                     via: 'get'    
      
    
    
  root 'menus#index'
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)    
    
  match "*path",                           to: 'menus#index',                                       via: 'get'
end
