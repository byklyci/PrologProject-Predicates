/**
 *April 2018 
 * Implemented by Yusuf Kalaycı for the Bogazici University CMPE260 course project. All the codes are implemented by me,there are no copy-paste or stolen codes here, all the implementation is based on the knowledge that I obtained in the PS section  and on the internet.Thanks to Professor Tunga Güngör and also assistants Hasan Ferit Enişer and Özlem Şimşek for intoducing me with such an excellent programming language.
 *
 * 
 */


/**
 * allTeams() is the first predicate in this part findall3 used and the length of the list is   
 * written on the terminal screen with the help of permutation of the all teams in the cl_base.pl
 */
allTeams(L,N):-
findall(X,team(X,_),L1),
length(L1,N),permutation(L1,L).


/**
 * wins() is the predicate that includes four variables and the main logic is finding weeks until the   
 * wanted week.The team can play other teams in the home or away so there are two findall for two list 
 * the append() is used for concenate two list together.I take the integer of score that more than  
 * other team.So the team wins.
 */
wins(T,W,L,N):-
findall(D, (match(Weeks_of,T,C,D,E),Weeks_of=<W,C>E),L1),
findall(B, (match(Weeks_of,B,C,T,E),Weeks_of=<W,E>C),L2),
append(L1,L2,L),
length(L,N).


/**
 * losses() is the predicate that includes four variables, the main logic is finding weeks until the   
 * wanted week.The team can play other teams in the home or away so there are two findall for two list 
 * the append() is used for concenate two list together.I take the integer of score that less than  
 * other team.So the team losses. 
 */
losses(T,W,L,N):-
findall(D,(match(A,T,C,D,E),A=<W,C<E),L1),
findall(B,(match(A,B,C,T,E),A=<W,C>E),L2),
append(L1,L2,L),
length(L,N).


/**
 * draws() is the predicate that include four variable and the main logic is finding weeks until the   
 * wanted week.The team can play other teams in the home or away so there are two findall for two list 
 * the append() is used for concenate two list together.I take the integer of score that equal the   
 * other team score.So the teams draw with each other. 
 */
draws(T,W,L,N):-
findall(D,(match(A,T,C,D,E),A=<W,C=E),L1),
findall(B,(match(A,B,C,T,E),A=<W,C=E),L2),
append(L1,L2,L),
length(L,N).

/**
 * sum_list(), sum the list and write the results.    
 */
sum_list([],0).
sum_list([C|E],S):-
sum_list(E,Rest),
S is C + Rest.

/**
 * scored() is the predicate that includes three variables and it takes the selected team score  
 * which means that the goal against other team inside wanted weeks.
 * The team can play other teams in the home or away so there are two findall for two list 
 * the append() is used for concenate two list together.sum_list() predicate calls here to sum the    
 * each week score for specified team. 
 */
scored(T,W,S):-
findall(C,(match(A,T,C,_,_),A=<W),L1),
findall(E,(match(A,_,_,T,E),A=<W),L2),
append(L1,L2,L),
sum_list(L,S).


/**
 * conceded() is the predicate that includes three variables and it takes the selected team conceded  
 * which means that other teams goal against selected team inside wanted weeks.
 * The team can play other teams in the home or away so there are two findall for two list 
 * the append() is used for concenate two list together.sum_list() predicate calls here to sum the    
 * each week concede a goal for specified team. 
 */
conceded(T,W,C):-
findall(C,(match(A,_,C,T,_),A=<W),L1),
findall(E,(match(A,T,_,_,E),A=<W),L2),
append(L1,L2,L),
sum_list(L,C).


/**
 * average() is the predicate that includes three variables and it takes the selected team score  
 * and also concede a goal inside wanted weeks.Average means that goal score-goal conceded.
 * The team can play other teams in the home or away and there are four findall for score predicate and  
 * the concede goal predicate.The append() is used for concenate two list together.
 * sum_list() predicate calls here to sum the lists then after the sum; the average can find 
 * with A is Src - Cnc.     
 */
average(T,W,A):-
findall(Cs,(match(Xw,T,Cs,_,_),Xw=<W),L1),
findall(Es,(match(Xq,_,_,T,Es),Xq=<W),L2),
append(L1,L2,L3),
sum_list(L3,Scr),
findall(Cc,(match(Xe,_,Cc,T,_),Xe=<W),L4),
findall(Ec,(match(Xr,T,_,_,Ec),Xr=<W),L5),
append(L4,L5,L6),
sum_list(L6,Cnc),
A is Scr - Cnc.

/**
 * insertion_sort () is the predicate that helps the order() predicate.It sort  
 * a given list in an orderly and use accumulator when doing it.It make insertion 
 * into the the list and inside the insertion_sort() the average() predicate calls  
 * because the sorting should be done with the help of it.  
 */
insertion_sort(List,Sorted,W):-i_sort(List,[],Sorted,W).
    i_sort([],Acc,Acc,_).
    i_sort([H|T],Acc,Sorted,W):-insertion(H,T,NAcc,M,W),i_sort(NAcc,[M|Acc],Sorted,W).
    insertion(X,[],[],X,_).   
    insertion(X,[Y|T],[Y|NAcc],M,W):-average(X,W,A1), average(Y,W,A2), (A1>A2),insertion(X,T,NAcc,M,W).
    insertion(X,[Y|T],[X|NAcc],M,W):-average(X,W,A1), average(Y,W,A2), (A1=<A2),insertion(Y,T,NAcc,M,W).
    insertion(X,[],[X],_).

/**
 * order() is the predicate that implemented order(L,W) where W (week) is given as   
 * constant and league order in that week will be retrieved in L.  
 * The order is decided according to average i.e the one with the highest average  
 * will be at the top. If the two teams have the same average then the order 
 * can be in any order.In order() predicate insertion_sort(),reverse() and findall() 
 * of all team is used.  
 */
order(L,W):-
	findall(X,team(X,_),L1),
	insertion_sort(L1,LA,W),
	reverse(LA,L).

/**
 * topThere() is the predicate that implement topThree([T1,T2, T3],W) where T1T2 and
 * T3 are the top teams when we are in the given week W.When implementing this   
 * predicate call order() predicates insiders.Then delete the athor elements in the L 
 * except first three of them.  
 */
topThree(L,W):-	
findall(X,team(X,_),L1),
	insertion_sort(L1,LA,W),
        delete([realmadrid,manutd,bdortmund,_,_,_,_],LA,L).

        




   
