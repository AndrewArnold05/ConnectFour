%following good programming practice of clear workspace and command window
%bfore starting game
clc
clear

% Initialize scene
my_scene = simpleGameEngine('ConnectFour.png',86,101);

% Set up variables to name the various sprites
empty_sprite = 1;
red_sprite = 2;
black_sprite = 3;

%Create a variable that repeats the loop while the game is running
gameRun = true;

%While loop runs the game forever due to variable gameRun always equalling
%true
while gameRun == true

    % Displays empty board with a welcome message and tells player how to start the game
    board_display = empty_sprite * ones(6,7);
    drawScene(my_scene,board_display)
    xlabel("Welcome to Connect Four, press enter to start")

    %Allows the user to look at the clear board until they are ready to start
    %the game (user starts game by pressing "return"
    k = getKeyboardInput(my_scene);
    while k ~= "return"
        k = getKeyboardInput(my_scene);
    end

    %By gathering the player names, we can communicate easier when it is a
    %player's turn, this is what the prompt does
    prompt = {'Player 1s name','Player 2s name'};
    dlgtitle = 'Player Names';
    fieldsize = [1 50; 1 50];

    %Collects the users names in a matrix named "answer"
    answer = inputdlg(prompt,dlgtitle,fieldsize);

    %The string 'str' is added to the player 1s & player 2s (using the
    %"answer" matrix) name in order to be used when it is
    %either players turn
    str = "'s turn, please press a number from 1-7";
    str1 = append(answer(1,:),str);
    str2 = append(answer(2,:),str);

    %Tells the users it is player one's turn
    xlabel(str1);

    %X is used to switch between player 1 and 2's turn using an if loop
    x = 1;

    %Run is used to wait for user input that is a number
    % 1-7, and if a key that is not 1-7 is pressed, will repeat until
    %the user presses 1-7
    run = false;
    while run == false
        try
            k = str2double(getKeyboardInput(my_scene));
            if k>=1 && k<=7
                run = true;
            else
            end
        catch
            xlabel("please press a number from 1-7")
        end
    end

    %Creates an empty 1x7 matrix
    z = zeros(1,7);

    %Turns the empty matrix into a matrix with values all equal to 1
    %This is later used to increase the height at which a chip in any given
    %column is placed
    z = z + 1;

    %Runs this loop forever, until "break" is used
    while x >= 0

        %If loop that requires a keypress 1-7 in order to place a chip, if
        %not, will once again tell user to press a number 1-7 and will wait
        %until one is pressed
        if k >= 1 && k <= 7

            %The if loop is what alternates both the text telling the user whose
            %turn it is and also alternates what color chip is placed in the board
            if x == 1

                %displays whose turn it is
                xlabel(str2)

                %Places a chip at a height determined by the number of
                %chips previously placed in the column by referencing the
                %1x7 "z" matrix previously created, then the column  number
                %is determined only by the keyboard press
                board_display(7 - z(k), k) = red_sprite;

                %redisplayies the board, now with a red chip in the
                %selected colum
                drawScene(my_scene, board_display)

                %Switchs value of x, allowing for it to be player 2's turn
                x = x - 1;

                %increases the height of which the next chip in the column
                % is placed
                z(k) = z(k) + 1;

            elseif x == 0

                %displays whose turn it is
                xlabel(str1)

                %Places a chip at a height determined by the number of
                %chips previously placed in the column by referencing the
                %1x7 "z" matrix previously created, then the column  number
                %is determined only by the keyboard press
                board_display(7 - z(k), k) = black_sprite;

                %redisplayies the board, now with a red chip in the
                %selected colum
                drawScene(my_scene, board_display)

                %Switchs value of x, allowing for it to be player 1's turn
                x = x + 1;

                %increases the height of which the next chip in the column
                % is placed
                z(k) = z(k) + 1;

            end

            %switches "run" to true in order to wait for user input 1-7
            %once loop is repeated
            run = true;
        else
            run = false;
        end

        %Checks to see if a win for red was detected using the isWin function
        %created below
        if checkForWin(board_display, red_sprite)

            %Displays a winning message for player one
            xlabel(answer(1,:) + " wins, Game over (press enter to restart).");

            %waits for keyboard input
            k = getKeyboardInput(my_scene);
            while k ~= "return"
                k = getKeyboardInput(my_scene);
            end
            %once enter is pressed, the game is restarted and the welcome
            %screen is displayed
            break;

        %Checks to see if a win for black was detected using the isWin function
        %created below
        elseif checkForWin(board_display, black_sprite)

            %Displays a winning message for player 2
            xlabel(answer(2,:) + " wins, Game over (press enter to restart).");

            %waits for keyboard input
            k = getKeyboardInput(my_scene);
            while k ~= "return"
                k = getKeyboardInput(my_scene);
            end
            %Once enter is pressed game is restarted and the welcome
            %screen is displayed
            break;
        end

        %if no win is detected then the loop once again waits for keyboard
        %input to place a chip
        %try loop also helps to catch an errors that may occur from
        %improper key presses
        try
            %checks if the number was between 1 & 7
            if run == false
                xlabel("please press a number from 1 - 7");
            end
            k = str2double(getKeyboardInput(my_scene));
        catch
            xlabel("please press a number from 1 - 7");
        end
    end
end

%Win condition function
function isWin = checkForWin(board, samecolor)
     [cols, rows] = size(board);
    %loops through all columns
     for col = 1:6
        %loops through all rows
        for row = 1:4
            %if four of same color are detected horizontally, isWin = true
            if board(col, row:row+3) == samecolor
                isWin = true;
                return;
            end
        end
     end
    %loops though all colums
    for col = 1:cols-3
        %loops through all rows
        for row = 1:rows
            %if four of the same color are detected vertically, isWin =
            %true
            if board(col:col+3, row) == samecolor
                isWin = true;
                return;
            end
        end
    end
    %loops through all columns
    for col = 1:cols-3
        %loops through all rows
        for row = 1:rows-3
            %if four of the same color are detected left to right
            % diagonally, isWin = true
            if diag(board(col:col+3, row:row+3)) == samecolor
                isWin = true;
                return;
            end
        end
    end
    %loops through all columns
    for col = 1:cols-3
        %loops through all rows
        for row = 4:rows
            %if four of the same color are detected right to left
            % diagonally, isWin = true
            if  diag(flipud(board(col:col+3, row-3:row)))  == samecolor
                isWin = true;
                return;
            end
        end
    end
    isWin = false;
end