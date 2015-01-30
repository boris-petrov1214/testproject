class HomeController < ApplicationController
  require 'redis'
  require 'json'
  def service
    count = params['n'] ? params['n'] : 1
    number = $redis.get("prev_number")
    if !number
      number = 1
    end
    result = []
    for i in 1..count.to_i
      while (true)
        number = number.to_i + 1
        flag = true
        for j in 2..Math.sqrt(number.to_f).to_i
          if number % j == 0
            flag = false
            next
          end
        end
        if flag == true
          result  << number
          break
        end
      end
    end
    $redis.set("prev_number", number)
    respond_to do |format|
      format.json {
        render :json => result,
               :status => :accepted

      }
    end

  end
end
