
is_category(C):- word(_, C).

categories(L):- setof(C, is_category(C), L).

available_length(L):- word(X, _), string_length(X, L), !. % to consider the cut predicate.

pick_word(W, L, C):- word(W, C), string_length(W, L).

correct_letters(L1, L2, L):- correct_letters_helper(L1, L2, LO), sort(LO, L).
correct_letters_helper([], _, []).
correct_letters_helper([H|T], L2, [H|TL]):- member(H, L2), correct_letters_helper(T, L2, TL).
correct_letters_helper([H|T], L2, CL):- \+member(H, L2), correct_letters_helper(T, L2, CL).

correct_positions(_, [], []):- !.
correct_positions([], _, []):- !.
correct_positions([H|T1], [H|T2], [H|T3]):- correct_positions(T1, T2, T3).
correct_positions([H1|T1], [H2|T2], L):- H1 \== H2, correct_positions(T1, T2, L).

build_kb:- write('Please enter a word and its category on separate lines:'), nl, read(X), (X = done; (read(Y), assert(word(X, Y)), build_kb)).

play:- play_cat.
play_cat:- write('Choose a category:'), nl, read(X), ((is_category(X), play_len(X)); (write('This category does not exist.'), nl, play_cat)).
play_len(X):- write('Choose a length:'), nl, read(L), ((pick_word(W, L, X), start(W, L)); (write('There are no words of this length.'), nl, play_len(X))).
start(W, L):- write('Game started. You have '), G is L + 1, write(G), write(' guesses.'), nl, game(W, G, L).
game(_, 0, _):- write('You Lost!').
game(W, G, L):- G > 0, write('Enter a word composed of '), write(L), write(' letters:'), nl, read(X), 
                    ((X = W, write('You Won!')); 
                    (string_length(X, LenX), ((LenX \== L, write('Word is not composed of '), write(L), write(' letters. Try again.'), nl, write('Remaining Guesses are '), write(G), nl, game(W, G, L)) ; 
                    ((G > 1, write('Correct letters are: '), string_chars(X, X1), string_chars(W, W1), correct_letters(X1, W1, L1), write(L1), nl, 
                    write('Correct letters in correct positions are: '), correct_positions(X1, W1, L2), write(L2), nl, 
                    TMP is G - 1, write('Remaining Guesses are '), write(TMP), nl, game(W, TMP, L));
                    (game(W, 0, L)))))).

main:- build_kb, play.