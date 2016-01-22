class OrdersController < ApplicationController

  before_action :set_menu,  only: [:a_new_order]
  before_action :set_order, only: [:update, :change_status_to_payed]

  def a_new_order
    @order = Order.new
  end
  
  def create
    @order = Order.new(order_params)
    @order.akey = akey
    @order.akey_payed = akey       
            
    if @order.save
      #OrderMailer.a_has_client_payed(@order).deliver    # email to CLIENT: with form_for_get_consult_after_pay & page_for_select_pay_way           
      flash.delete(:order_name)
      flash.delete(:order_email)
      flash.delete(:translit)
      redirect_to '/click_for_pay'                      # redirect to payment GATEWAY
      
    else  
      flash[:order_name] = @order.name
      flash[:order_email] = @order.email    
      flash[:translit] = flash[:translit] || 'lichnaja-zhizn'
      flash[:order_errors] = @order.errors
      
      #if cookies are OFF -> show errors in FIRST menu url-case
      @url = '/about/' + 
        if flash[:translit]
          "#{flash[:translit]}"
        else
          'lichnaja-zhizn'
        end        
      redirect_to "#{@url}"
    end  
  end

#*********************************************************************************************************************************************  
  
  
  # client ends the PAY PROCESS
  # and goes from her email
  # to ask for CONSULTATION TEXT       
            
  def c_form_for_get_consult_after_pay                # for ENTER payment data (2 last DIGITS of credit card & PAYMENT DATE) 
    @name = params[:name]
    @id = params[:id]
    @akey = params[:akey]
    if Order.where(id: @id).empty? or Order.find(@id).akey != @akey
      redirect_to '/'
    else
      @order = Order.find(@id)
    end  
  end    
  
  def update
    @order.update_attributes(order_params)    
    
    if @order.save
      #OrderMailer.b_confirm_pay_info_to_psyc_for_check(@order).deliver    
      flash.delete(:order_name)
      flash.delete(:order_email)
      flash.delete(:translit)    
      redirect_to '/request_sent/1'
    else
      flash[:order_when_payed] = @order.when_payed
      flash[:order_end_cards] = @order.end_cards
      flash[:order_errors] = @order.errors
      
      redirect_to "/i_have_payed/#{@order.name}/#{@order.akey}/#{@order.id}"
    end
  end
   
  def d_pay_info_success_sent
    @order_info_page = OrderInfoPage.find(params[:id])
  end
#*********************************************************************************************************************************************  

    
  def change_status_to_payed    
    @order.payed = true
    @order.akey_payed = nil
    
    @order.save
    OrderMailer.c_info_to_client_that_pay_data_is_right(@order).deliver
    redirect_to '/request_sent/2'     
  end 
#*********************************************************************************************************************************************  
    
  
  def order_params
    params.require(:order).permit(:payed, :name, :email, :akey, :end_cards, :sum_for_pay, :when_payed, :akey_payed, :able)
  end  
  
    
  private
  def set_menu
    @menu = Menu.find_by translit:(params[:translit])   # 1)   get menu-record with title == params[:translit]     // like 'lichnaja-zhizn' etc.
    @menu ||= Menu.first                                # 2)   if record not found -> display the first record  
    flash[:translit] = params[:translit]
  end  
  
  def set_order
    @order = Order.find(params[:id])
  end                                                      
end    
  
