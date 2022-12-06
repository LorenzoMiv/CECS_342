% day of week observed on
weekday(1). 	 % T
weekday(2).		 % W
weekday(3).		 % TH
weekday(4).		 % F

% objects that were supposedly seen
object(balloon).
object(clothesline).
object(frisbee).
object(watertower).

% succeed if all elements of the argument list are bound and different.
% fail if any elements are unbound or equal to some other element.
difference([H | T]) :- member(H, T), !, fail.        
difference([_ | T]) :- difference(T).            		  
difference([_]).                                     				  

% determines which day is early or later
earlier(EarlierDay, LaterDay) :- EarlierDay < LaterDay.

solve :-
    % people, the objects, and days 
    Person = [[barada, BObj, BDay],
                [gort, GObj, GDay],
                [klatu, KObj, KDay],
                [nikto, NObj, NDay]],
    
    % each person gets told about the object they observed
    object(BObj), object(GObj), object(KObj), object(NObj),
    difference([BObj, GObj, KObj,NObj]),
    

    % four sightings on different days 
    weekday(BDay), weekday(GDay), weekday(KDay), weekday(NDay),
    difference([BDay, GDay, KDay, NDay]),
    
    % 1. Klatu made sighting earlier in week than one who saw ballon,
    %     but later in week than one who spotted frisbee(who isnt Ms.Gort)
    member([_, balloon, BallonDay], Person),
    earlier(KDay, BallonDay), 									% Klatu saw earlier than balloon person
    member([_, frisbee, FrisbeeDay], Person),
    earlier(FrisbeeDay, KDay), 									% Frisbee person saw earlier than Klatu
    \+ member([gort, frisbee, _], Person),			   % Gort didn't spot frisbee
    
    % 2. Friday's sighting was made by either Ms.Barrada or the one who saw a clothesline(or both)
    (member([barada, _, 4], Person);
     member([_, clothesline, 4], Person)),
    
    % 3. Nikto did not make his sighting on Tuesday
    \+ member([nikto, _, 1], Person),
    
    % 4. Klatu isn't the one whose object turned out to be a water tower
    \+ member([klatu, watertower, _], Person),
    
    % prints out the solution with given parameters
    printSol(gort, GObj, GDay),
    printSol(nikto, NObj, NDay),
    printSol(klatu, KObj, KDay),
    printSol(barada, BObj, BDay).
                                                                                       
%function that prints solution
printSol(Person, Object, DayNum) :-
    format('~w sighted ~w on ', [Person, Object]),
    ( DayNum =:= 1 -> write("Tuesday");
      DayNum =:= 2 -> write("Wednesday");
      DayNum =:= 3 -> write("Thursday");
                      write("Friday")),
    nl.
