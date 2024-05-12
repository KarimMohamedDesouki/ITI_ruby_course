require 'date'

module Logger
  LOG_FILE = "app.logs"

  def log_info(message)
    log("info", message)
  end

  def log_warning(message)
    log("warning", message)
  end

  def log_error(message)
    log("error", message)
  end

  private

  def log(log_type, message)
    timestamp = DateTime.now.strftime("%Y-%m-%dT%H:%M:%S%:z")
    log_entry = "#{timestamp} -- #{log_type} -- #{message}"
    File.open(LOG_FILE, "a") { |file| file.puts(log_entry) }
  end
end

class User
  attr_reader :name, :balance

  def initialize(name, balance)
    @name = name
    @balance = balance
  end
   # Define a writer method for the balance attribute
   def balance=(new_balance)
    @balance = new_balance
  end
end

class Transaction
  attr_reader :user, :value

  def initialize(user, value)
    @user = user
    @value = value
  end
end

class Bank
  def process_transactions(transactions, &block)
    raise NotImplementedError, "You must implement the process_transactions method in a subclass."
  end
end

class CBABank < Bank
  include Logger

  def process_transactions(transactions, &block)
    # Log the start of transaction processing
    log_info("Processing Transactions #{transactions.map { |t| "User #{t.user.name} transaction with value #{t.value}" }.join(', ')}...")
    transactions.each do |transaction|
      begin
        if transaction.user.instance_of?(User)
          newbalance = transaction.user.balance + transaction.value
          if newbalance < 0
            raise StandardError, "Not Enough Balance in your Account"
          elsif newbalance == 0
            log_warning("#{transaction.user.name} your Balance is 0")
          end
          transaction.user.balance = newbalance
          log_info("user #{transaction.user.name} transaction value number #{transaction.value} has Succeeded")
          block.call("success")
        else
          raise StandardError, "#{transaction.user.name} not exist in the bank!!"
        end
      rescue => e
        log_error("User #{transaction.user.name} transaction with value #{transaction.value} failed with message #{e.message}")
        block.call("failure") # Moved inside the rescue block to handle transaction failure
      end
    end
  end
end

users = [
  User.new("Ali", 200),
]

out_side_bank_users = [
  User.new("Menna", 400),
]

transactions = [
  Transaction.new(users[0], -200),

]

cba_bank = CBABank.new
cba_bank.process_transactions(transactions) do |result|
  if result == "success"
    puts "Call endpoint for success of User transaction"
  elsif result == "failure"
    puts "Call endpoint for failure of User transaction"
  end
end
