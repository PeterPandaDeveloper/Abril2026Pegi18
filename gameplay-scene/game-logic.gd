extends Control

var card_names = []
var card_values = []
var card_images = {}

var playerScore = 0
var dealerScore = 0
var playerCards = []
var dealerCards = []

var cardsShuffled = {}
var ace_found
var hold_s: float = 0.0

func _ready():
	$Replay.visible = false
	$WinnerText.visible = false
	$PlayerHitMarker.visible = false
	$DealerHitMarker.visible = false
	get_tree().root.content_scale_factor
	updateText()
	create_card_data()
	
	await get_tree().create_timer(0.7).timeout
	generate_card("player")
	updateText()
	await get_tree().create_timer(0.5).timeout
	generate_card("player")
	updateText()
	
	await get_tree().create_timer(0.5).timeout
	generate_card("dealer", true)
	updateText()
	await get_tree().create_timer(0.5).timeout
	generate_card("dealer")
	updateText()
	await get_tree().create_timer(1).timeout
	
	if playerScore == 21:
		playerWin(true)

func _process(delta):
	# Feedback Visual con Barra de Salida
	if has_node("BarraSalida"):
		if Input.is_key_pressed(KEY_S):
			hold_s += delta
			$BarraSalida.value = (hold_s / 0.8) * 100
			if hold_s >= 0.8:
				# ¡AQUÍ ESTÁ EL ARREGLO! La ruta completa:
				get_tree().change_scene_to_file("res://gameplay-scene/BarScene.tscn")
		else:
			hold_s = 0.0
			$BarraSalida.value = 0
			
func _on_hit_pressed():
	$PlayerHitMarker.visible = true
	generate_card("player")
	$AnimationPlayer.play("HitAnimationP")
	updateText()
	if playerScore == 21:
		_on_stand_pressed() 
	elif playerScore > 21:
		check_aces() 
		if playerScore > 21: 
			playerLose()
			
func check_aces():
	while playerScore > 21:
		ace_found = false
		for card_index in range(len(playerCards)):
			if playerCards[card_index][0] == 11: 
				playerCards[card_index][0] = 1 
				ace_found = true
				break
		if not ace_found:
			break 
		recalculate_player_score()
		updateText()
	
func recalculate_player_score():
	playerScore = 0
	for card in playerCards:
		playerScore += card[0]

func _on_stand_pressed():
	$Buttons/VBoxContainer/Hit.disabled = true
	$Buttons/VBoxContainer/Stand.disabled = true
	$Buttons/VBoxContainer/OptimalMove.disabled = true
	$DealerHitMarker.visible = true
	$WhoseTurn.text = "Dealer's\nTurn"
	
	await get_tree().create_timer(0.5).timeout
	var dealer_hand_container = $Cards/Hands/DealerHand
	
	var child_to_remove = dealer_hand_container.get_child(0)
	child_to_remove.queue_free() 
	
	var card = dealerCards[0]
	var card_texture_rect = TextureRect.new()
	var card_texture = ResourceLoader.load(card[1])
	card_texture_rect.texture = card_texture

	dealer_hand_container.add_child(card_texture_rect)
	dealer_hand_container.move_child(card_texture_rect, 0)
	
	if card[0] == 11 and dealerScore > 10: 
		dealerScore += 1
	else:
		dealerScore += card[0]
	updateText()
	
	while dealerScore < playerScore and dealerScore < 17:
		await get_tree().create_timer(1.5).timeout
		$AnimationPlayer.play("HitAnimationD")
		generate_card("dealer")
		updateText()
		
	if dealerScore > 21 or dealerScore < playerScore: 
		playerWin()
	elif playerScore < dealerScore and dealerScore <= 21: 
		playerLose()
	else: 
		playerDraw()
	
func create_card_data():
	for rank in range(2, 11):
		for suit in ["clubs", "diamonds", "hearts", "spades"]:
			card_names.append(str(rank) + "_" + suit)
			card_values.append(rank)

	for face_card in ["jack", "queen", "king", "ace"]:
		for suit in ["clubs", "diamonds", "hearts", "spades"]:
			card_names.append(face_card + "_" + suit)
			if face_card != "ace":
				card_values.append(10)
			else:
				card_values.append(11)	
				
	for card in range(len(card_names)):
		card_images[card_names[card]] = [card_values[card], 
			"res://assets/images/cards_pixel/" + card_names[card] + ".png"]
		
	card_images["back"] = [0, "res://assets/images/cards_alternatives/card_back_pix.png"]
	
	cardsShuffled = card_names.duplicate()
	cardsShuffled.shuffle()
	
func generate_card(hand, back=false):
	var random_card

	if back:
		random_card = card_images["back"]
		dealerCards.append(card_images[cardsShuffled.pop_back()])
	else:
		var random_card_name = cardsShuffled.pop_back()
		random_card = card_images[random_card_name] 

	var card_texture = ResourceLoader.load(random_card[1])
	var card_texture_rect = TextureRect.new()
	card_texture_rect.texture = card_texture
	
	var card_hand_container
	if hand == "player":
		card_hand_container = $Cards/Hands/PlayerHand
		if random_card[0] == 11 and playerScore > 10: 
			playerScore += 1
		else:
			playerScore += random_card[0]
		playerCards.append(random_card)
	elif hand == "dealer":
		card_hand_container = $Cards/Hands/DealerHand
		if random_card[0] == 11 and dealerScore > 10: 
			dealerScore += 1
		else:
			dealerScore += random_card[0]
		dealerCards.append(random_card)
	else:
		return
		
	card_hand_container.add_child(card_texture_rect)

func updateText():
	$DealerScore.text = str(dealerScore)
	$PlayerScore.text = str(playerScore)

func playerLose():
	$WinnerText.text = "DEALER\nWINS"
	$WinnerText.set("theme_override_colors/font_color", "ff5342")
	$Buttons/VBoxContainer/Hit.disabled = true
	$Buttons/VBoxContainer/Stand.disabled = true
	$Buttons/VBoxContainer/OptimalMove.disabled = true
	
	# RESTAMOS DINERO
	if get_node_or_null("/root/Global"):
		Global.dinero -= 10
		print("Has perdido 10. Dinero restante: ", Global.dinero)
		if Global.auto_guardado:
			Global.guardar_partida()
	else:
		print("¡ERROR: Global no encontrado!")
	
	await get_tree().create_timer(1).timeout
	$WinnerText.visible = true
	await get_tree().create_timer(0.5).timeout
	$Replay.visible = true
	
func playerWin(blackjack=false):
	var ganancia = 10
	if blackjack:
		$WinnerText.text = "PLAYER WINS\nBY BLACKJACK"
		ganancia = 20
	
	$Buttons/VBoxContainer/Hit.disabled = true
	$Buttons/VBoxContainer/Stand.disabled = true
	$Buttons/VBoxContainer/OptimalMove.disabled = true
	
	# SUMAMOS DINERO
	if get_node_or_null("/root/Global"):
		Global.dinero += ganancia
		print("Has ganado ", ganancia, ". Dinero total: ", Global.dinero)
		if Global.auto_guardado:
			Global.guardar_partida()
	else:
		print("¡ERROR: Global no encontrado!")
	
	await get_tree().create_timer(1).timeout
	$WinnerText.visible = true
	await get_tree().create_timer(0.5).timeout
	$Replay.visible = true

func playerDraw():
	$WinnerText.text = "DRAW"
	$WinnerText.set("theme_override_colors/font_color", "white")
	$Buttons/VBoxContainer/Hit.disabled = true
	$Buttons/VBoxContainer/Stand.disabled = true
	$Buttons/VBoxContainer/OptimalMove.disabled = true
	await get_tree().create_timer(1).timeout
	$WinnerText.visible = true
	await get_tree().create_timer(0.5).timeout
	$Replay.visible = true

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://gameplay-scene/BarScene.tscn")
	
func _on_replay_pressed():
	get_tree().change_scene_to_file("res://gameplay-scene/game.tscn")

func _on_button_pressed():
	if len(dealerCards) < 2: 
		return
	var dealerUpCard = dealerCards[2][0]
	var hasAce = playerHasAce(playerCards)
	
	if hasAce:
		if playerScore >= 19:
			_on_stand_pressed()
		elif playerScore == 18 and dealerUpCard <= 8:
			_on_stand_pressed()
		elif playerScore == 18 and dealerUpCard >= 9:
			_on_hit_pressed()
		else:
			_on_hit_pressed()
	else:
		if playerScore >= 17 and playerScore <= 20:
			_on_stand_pressed()
		elif playerScore >= 13 and playerScore <= 16:
			if dealerUpCard >= 2 and dealerUpCard <= 6:
				_on_stand_pressed()
			else:
				_on_hit_pressed()
		elif playerScore == 12:
			if dealerUpCard >= 4 and dealerUpCard <= 6:
				_on_stand_pressed()
			else:
				_on_hit_pressed()
		elif playerScore >= 4 and playerScore <= 11:
			_on_hit_pressed()
		else:
			_on_stand_pressed()

func playerHasAce(cards):
	for card in cards:
		if card[0] == 11:
			return true
	return false
