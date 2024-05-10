require 'json'
class Inventory

    def initialize(title,authen,isbn)
        @books_file = "Books.json"
        @Books = []
        AddBook(title,authen,isbn)
    end

    # def loadBook
    #     if File.exist?(@BOOKS_FILE) #this will be true or false naming convention ?
    #         File.readlines(@BOOKS_FILE).each do |line|
    #             @books.push(JSON.parse(line))
    #         end
    #     end
    # end
    def loadBook
        if File.exist?(@books_file)
            File.readlines(@books_file).each do |line|
                @Books.push(JSON.parse(line))
            end
        end
    end

    def ListBooks
        @Books.each do |book|
            puts "#{book['title']} written by #{book['authen']} and Number #{book['isbn']}"
        end
    end

    def AddBook(title,authen,isbn)
        @Books.push({'title' => title,'authen' => authen, 'isbn' => isbn})
        savebook
    end

    def RemoveBookByISBN(isbn)
        @Books.reject! { |book| book['isbn'] == isbn }
        savebook
    end
    

    def savebook
        File.open(@books_file,"w") do |file|
            @Books.each do |book|
                file.puts(book.to_json)
            end
        end
    end
end

inventory =Inventory.new('LordofRings','KArimMohamed','10123')

inventory.AddBook("Harrypotter","AhmedMahmad","1234")
inventory.AddBook("Harrypotter6","Mahmad","5697")
inventory.AddBook("Malificent","Mahmad","5697")

inventory.ListBooks