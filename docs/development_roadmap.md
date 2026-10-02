You are helping me develop a polished 3D Pokémon TCG shop tycoon game in Godot.

This is intended to become a large, high-quality game project, so I want you to prioritize clean architecture, modular systems, maintainability, scalability, good performance, and polished presentation.

Do NOT attempt to build the entire game at once.

Work through the project in clearly defined development phases. At the end of each phase, stop and give me:

1. A concise summary of everything you implemented.
2. A list of files created.
3. A list of files modified.
4. Any new controls or inputs.
5. Exact instructions for how I should test the phase.
6. Any known limitations.
7. What the next phase would contain.

Do not begin the next phase until I explicitly tell you to continue.

==================================================
PROJECT CONCEPT
==================================================

The game is a 3D Pokémon Trading Card Game shop tycoon.

The player begins with a tiny card shop and gradually transforms it into a large, prestigious Pokémon TCG store.

The primary gameplay pillars are:

1. RUNNING A CARD SHOP
2. COLLECTING POKÉMON CARDS
3. OPENING BOOSTER PACKS
4. UPGRADING AND CUSTOMIZING THE STORE
5. BUYING AND SELLING PRODUCTS
6. BUILDING A PERSONAL CARD COLLECTION
7. MANAGING CUSTOMERS AND EMPLOYEES
8. EXPERIENCING HIGH-QUALITY CARD VISUALS AND ANIMATIONS

The tone should be relaxing, satisfying, colorful, polished, and highly replayable.

The graphics should be high quality but stylized rather than photorealistic.

Think:

- colorful stylized 3D environments
- clean materials
- smooth animation
- appealing lighting
- soft but detailed textures
- exaggerated readable proportions
- expressive customers
- especially detailed trading cards

The cards themselves should receive significantly more visual detail than the surrounding environment.

==================================================
IMPORTANT DEVELOPMENT RULES
==================================================

Use the current stable Godot 4 release available in the project.

Use GDScript unless there is a strong technical reason not to.

Favor composition over large inheritance hierarchies.

Avoid giant scripts.

Avoid tightly coupling unrelated gameplay systems.

Do not put major gameplay systems directly inside the player script.

Use signals, resources, components, managers, and reusable scenes appropriately.

Avoid hardcoding card content throughout gameplay scripts.

Cards, products, customers, furniture, upgrades, sets, rarity tables, and similar content should be data-driven.

Make systems scalable enough to eventually support thousands of cards.

Use descriptive names for scripts, classes, scenes, nodes, variables, resources, and functions.

Use typed GDScript where practical.

Add comments for important architecture decisions, but do not clutter simple code with unnecessary comments.

Do not add unnecessary systems before they are needed.

Do not replace working systems without explaining why.

Do not silently remove existing functionality.

Before editing an existing system, inspect how it currently works.

Whenever practical, preserve backward compatibility with existing project data.

==================================================
HIGH-LEVEL PROJECT ORGANIZATION
==================================================

Keep the project clean and organized.

A structure similar to this is encouraged:

res://

assets/
    audio/
    cards/
    characters/
    environment/
    furniture/
    icons/
    materials/
    models/
    particles/
    products/
    textures/

data/
    cards/
    card_sets/
    products/
    furniture/
    customers/
    upgrades/
    employees/

scenes/
    cards/
    characters/
    customers/
    furniture/
    player/
    products/
    shop/
    ui/
    world/

scripts/
    cards/
    customers/
    economy/
    employees/
    furniture/
    interaction/
    inventory/
    player/
    products/
    shop/
    systems/
    ui/

autoload/
    GameManager.gd
    SaveManager.gd
    CardDatabase.gd
    EconomyManager.gd

shaders/
    cards/
    environment/
    effects/

The exact organization may change if a better architecture emerges, but it must remain clear and scalable.

==================================================
CORE GAME LOOP
==================================================

The basic gameplay loop should eventually be:

Order Pokémon TCG products
↓
Receive inventory
↓
Open boxes
↓
Stock shelves and display cases
↓
Optionally open products for personal cards
↓
Customers enter the store
↓
Customers browse products
↓
Customers purchase items
↓
Player earns money
↓
Player buys more stock
↓
Player improves the store
↓
New products and systems unlock
↓
Player expands personal collection
↓
Repeat

The player should constantly choose between:

SELLING valuable cards/products for profit

and

KEEPING valuable cards for their personal collection.

==================================================
PLAYER
==================================================

The game should use a first-person perspective.

Eventually the player should be able to:

- walk
- look around
- sprint
- interact with objects
- pick up objects
- carry objects
- rotate held objects
- place objects
- inspect cards
- open boxes
- open booster packs
- stock shelves
- operate the cash register
- customize the store

Movement should feel smooth and polished rather than floaty.

Use acceleration/deceleration where appropriate.

The interaction system should be reusable rather than hardcoded individually for every object.

==================================================
INTERACTION SYSTEM
==================================================

Create a reusable interaction framework.

Interactable objects should eventually support actions such as:

- Pick Up
- Inspect
- Open
- Use
- Stock
- Purchase
- Sell
- Rotate
- Place
- Activate

Avoid creating entirely separate interaction logic for every item.

A component/interface-style system is preferred.

The crosshair or interaction UI should clearly indicate when something is interactable.

==================================================
PHYSICAL ITEM SYSTEM
==================================================

Products should exist as physical 3D objects.

Examples:

- booster packs
- booster boxes
- card boxes
- individual cards
- shipping boxes
- binders
- card sleeves
- deck boxes
- furniture

Objects should be capable of carrying gameplay data while also being represented physically in the game world.

==================================================
CARD DATABASE
==================================================

Cards must be data-driven.

Do NOT write separate gameplay scripts for individual cards.

Each card entry should eventually contain fields such as:

card_id
name
pokemon_name
set_id
collector_number
rarity
variant
type
market_value
art_texture
foil_mask
collection_category
is_owned
quantity_owned

The exact schema can evolve.

Use Godot Resources, JSON, or another appropriate data structure.

The card database must be scalable enough to handle thousands of cards.

==================================================
CARD VARIANTS
==================================================

Support a flexible card variant system.

Possible variants include:

Normal
Reverse Holo
Holo Rare
Ultra Rare
Illustration Rare
Special Illustration Rare
Secret Rare
Gold
Rainbow
Promo
Alternate Art

The system should not assume every card has every variant.

==================================================
3D CARD SYSTEM
==================================================

Cards should physically exist as thin 3D objects.

When inspecting a card, the player should eventually be able to:

- hold it close to the camera
- rotate it
- tilt it
- zoom slightly
- view the front
- view the back
- see foil reacting dynamically to viewing angle and lighting

Cards should maintain correct proportions.

Card artwork should remain crisp.

The inspection system should work with mouse and controller.

==================================================
FOIL / HOLOGRAPHIC SHADER SYSTEM
==================================================

One of the most important visual systems is the foil shader.

Create a reusable shader architecture that can produce several foil effects using masks.

Possible effects:

NORMAL HOLO
Foil visible primarily on selected artwork areas.

REVERSE HOLO
Foil primarily outside the central artwork.

RAINBOW FOIL
Hue shifts based on camera/view angle.

SECRET RARE
Strong diffraction effect with controlled sparkle.

FULL ART FOIL
Multiple subtle foil layers.

Foil effects should respond to:

camera direction
card orientation
light
viewing angle

Avoid making the effect look like a simple scrolling rainbow texture.

The effect should feel physically connected to the surface of the card.

Allow different cards to use different foil masks and foil parameters.

==================================================
BOOSTER PACK SYSTEM
==================================================

Booster packs should use data-driven rarity tables.

A set should define:

available cards
possible rarities
slot structure
pull probabilities
variant probabilities

A booster pack should generate cards when opened.

The system must support different sets having different pack structures.

Eventually include:

normal cards
reverse foil slot
rare slot
special pulls
secret rares
special variants

RNG logic should be separated from presentation.

==================================================
PACK OPENING EXPERIENCE
==================================================

Pack opening should be one of the most polished parts of the game.

Eventually the sequence should feel approximately like:

Player picks up booster pack.

Player activates opening mode.

Pack moves into view.

Player tears the wrapper.

Cards slide out.

Cards are shown one at a time.

Player advances through cards.

Rare cards receive stronger visual treatment.

Possible effects include:

- foil shimmer
- sparkles
- subtle particle effects
- camera movement
- sound effects
- rarity reveal animation
- UI notification for new collection entries
- controller vibration

Pack opening should support multiple modes later:

Manual Opening

Quick Opening

Mass Opening

Do not implement all of these immediately.

Build the underlying system first.

==================================================
BOOSTER BOXES
==================================================

Booster boxes should eventually exist physically.

Possible interaction sequence:

Remove plastic wrapping.

Open cardboard lid.

Reveal booster packs.

Take individual packs out.

Allow packs to be opened or stocked.

==================================================
PERSONAL COLLECTION
==================================================

The player should have a personal Pokémon card collection.

Eventually create a binder interface.

The binder should support:

- browsing by set
- browsing by Pokémon
- browsing by rarity
- viewing owned cards
- viewing missing cards
- duplicate counts
- completion percentage
- variant completion
- searching cards

Example:

Scarlet & Violet Base Set

183 / 198 Cards

92.4% Complete

Missing cards should appear as silhouettes or empty numbered slots.

==================================================
STORE INVENTORY
==================================================

The store needs a real inventory system.

Inventory should track:

sealed products
single cards
furniture
supplies
incoming shipments

Inventory data should be separate from physical world objects.

Example:

Player owns:

24 Booster Packs
3 Booster Boxes
7 Singles
2 Empty Shelving Units

Physical world instances should reference inventory entries appropriately.

==================================================
PRODUCT ORDERING
==================================================

Eventually the player should order products through a distributor interface.

Possible categories:

Booster Packs
Booster Boxes
Elite Trainer-style products
Collection Boxes
Tins
Starter Decks
Accessories
Card Sleeves
Binders

Orders should cost money.

Products should arrive after a configurable delay.

Future expansion could include physically delivered shipment boxes.

==================================================
STORE SHELVING
==================================================

Products should physically appear on shelves.

Each shelf should know:

product type
capacity
current quantity
price

The player should be able to stock shelves manually.

Shelves should visually update as products are added or removed.

Customers should physically remove products when purchasing them.

==================================================
SINGLE CARD DISPLAY CASES
==================================================

Expensive individual cards should eventually be placed inside display cases.

The player should be able to:

choose card
assign sale price
place card
remove card

Customers should inspect available singles.

Rare customers may specifically visit the shop searching for particular cards.

==================================================
CUSTOMERS
==================================================

Customers should feel like actual shoppers rather than walking money dispensers.

Potential customer archetypes include:

Casual Player
Collector
Competitive Player
Parent
Child
Hardcore Collector
Investor
Tourist
Completionist

Different customer types should have:

budget ranges
product preferences
rarity preferences
shopping duration
patience
price sensitivity

Customer behavior should eventually include:

entering shop
browsing
choosing shelves
inspecting products
deciding whether to buy
carrying products
queueing
checking out
leaving

Avoid calculating every decision every frame.

Use state machines or another efficient behavioral architecture.

==================================================
CHECKOUT SYSTEM
==================================================

Early in the game, the player should personally operate checkout.

Possible checkout flow:

Customer approaches counter.

Products appear at checkout.

Player scans/selects items.

Payment occurs.

Customer leaves.

Eventually employees should automate this.

Keep the checkout system modular so automation can later reuse the same transaction logic.

==================================================
ECONOMY
==================================================

Create a centralized economy system.

Track:

cash
expenses
sales
inventory value
shop value
daily profit
daily revenue

Do not modify money directly from random scripts.

Use centralized economy functions such as:

add_money()
remove_money()
can_afford()
record_sale()
record_expense()

Exact naming may differ.

==================================================
CARD MARKET VALUES
==================================================

Cards should eventually have simulated market values.

Card prices can potentially change based on:

rarity
popularity
competitive usefulness
supply
demand
reprints
events
set age

Do not implement an overly complicated dynamic market immediately.

Design the architecture so dynamic prices can be added later.

==================================================
STORE REPUTATION
==================================================

The store should eventually have a reputation system.

Possible factors:

fair prices
inventory variety
shop cleanliness
decor
customer service
queue time
tournament quality
rare card availability

Higher reputation could unlock:

better distributors
higher-spending customers
special products
larger store expansions
rare collectors

==================================================
STORE CUSTOMIZATION
==================================================

The player should eventually place furniture.

Furniture examples:

shelves
display cases
checkout counters
storage racks
play tables
chairs
posters
statues
plants
lighting
decorations
vending machines

Furniture should use reusable placement logic.

Allow:

preview placement
valid/invalid placement feedback
rotation
collision checking
confirmation
cancel placement

Do not force everything to use a strict grid unless a hybrid snapping system is useful.

==================================================
STORE UPGRADES
==================================================

The player begins with a very small shop.

Possible progression:

Tier 1:
Tiny shop

Tier 2:
Neighborhood card store

Tier 3:
Large hobby shop

Tier 4:
Premium TCG store

Tier 5:
Large card superstore

Tier 6:
Collector destination store

Expansions should provide meaningful benefits, not just more floor space.

==================================================
EMPLOYEE SYSTEM
==================================================

Employees should eventually automate repetitive tasks.

Potential roles:

Cashier
Stocker
Card Specialist
Cleaner
Security
Tournament Organizer
Online Fulfillment Worker

Employees could have:

wage
skill
experience
speed
morale
role

Do not implement employees until the core shop gameplay works.

==================================================
TOURNAMENTS
==================================================

A later-game feature should allow tournaments.

Players could place tables and create a tournament area.

Tournaments could:

increase store reputation
attract customers
increase product sales
unlock rewards
cause temporary card demand increases

Actual Pokémon TCG battle simulation is NOT required for the initial project.

==================================================
SAVE SYSTEM
==================================================

Implement saving early enough that major systems can persist reliably.

Eventually save:

money
player position if necessary
store expansion
furniture
inventory
cards owned
collection progress
prices
employees
upgrades
game day/time
settings

Use versioned save data.

Future changes should not automatically destroy older saves.

==================================================
DAY / TIME SYSTEM
==================================================

Eventually include a simple day cycle.

Possible flow:

Morning:
prepare store

Open:
customers arrive

Evening:
store closes

End of Day:
financial report

Do not make days unnecessarily stressful.

This should remain a relatively relaxing tycoon game.

==================================================
SOUND DESIGN
==================================================

Design systems so audio can later be added cleanly.

Important sounds include:

pack tearing
card sliding
foil shimmer
button clicks
cash register
store door bell
product scanning
boxes opening
shelf stocking
rare card reveal

Audio should strongly reinforce tactile interactions.

==================================================
ANIMATION QUALITY
==================================================

Animations should feel smooth and intentional.

Important animation areas:

first-person interaction
picking up items
placing items
cards rotating
pack opening
product stocking
customer walking
customer browsing
checkout
rare card reveal
UI transitions

Avoid instantly teleporting objects unless required for debugging.

Use easing/tweening where appropriate.

==================================================
GRAPHICS / LIGHTING
==================================================

Use Godot's 3D lighting and post-processing carefully.

The visual target is polished stylized 3D.

Possible features:

soft shadows
ambient lighting
reflection probes where useful
screen-space effects
subtle bloom
depth of field during card inspection
color grading
high-quality anti-aliasing

Performance should remain a priority.

Avoid expensive effects that provide little visible benefit.

==================================================
PERFORMANCE
==================================================

The game may eventually contain:

many customers
many shelf products
many physical cards
large stores
many decorations

Plan for performance.

Possible future techniques:

object pooling
LOD
occlusion culling
MultiMesh
reduced AI update frequency
distance-based simulation
efficient collision layers
cached data

Do not prematurely optimize simple systems, but avoid architectures that obviously scale poorly.

==================================================
INPUT
==================================================

Design controls so mouse/keyboard and controller can both eventually work.

Suggested PC controls:

WASD = Movement

Mouse = Camera

Shift = Sprint

E = Interact

Left Click = Primary interaction

Right Click = Secondary interaction

Mouse Wheel = Rotate/inspect context where appropriate

Escape = Menu

Controller mappings should later be added through Godot's Input Map rather than hardcoded device checks.

==================================================
DEBUGGING
==================================================

Create useful developer/debug tools during development.

Possible debug features:

FPS
player position
customer count
inventory count
money
current interaction target
current game state

Use toggleable debug UI rather than permanent development text.

Avoid leaving debug spam in production output.

==================================================
PLACEHOLDER ASSETS
==================================================

When custom artwork, Pokémon card images, models, animations, sounds, or textures are unavailable, use simple placeholders.

Do NOT block development because final art is missing.

Examples:

colored boxes for products

simple humanoids for customers

plain cards with text labels

basic shelves

temporary icons

Keep placeholder assets easy to replace later.

==================================================
POKÉMON-SPECIFIC CONTENT
==================================================

Design gameplay systems generically enough that the underlying game could later use either Pokémon cards or an original fictional TCG.

Avoid coding essential gameplay logic around a specific Pokémon.

Card names, images, sets, rarity information, products, and related content should come from data.

This will make future expansion much easier.

==================================================
DEVELOPMENT PHASES
==================================================

Use this roadmap.

Do not skip ahead.

--------------------------------
PHASE 1
PROJECT FOUNDATION
--------------------------------

Set up:

project structure
coding conventions
autoload architecture
input actions
main game scene
basic test environment
debug framework
basic save architecture skeleton

No tycoon gameplay yet.

--------------------------------
PHASE 2
FIRST-PERSON PLAYER
--------------------------------

Implement:

movement
camera
mouse look
sprint
gravity
collision
smooth acceleration
interaction raycast
basic crosshair

Create a simple test room.

--------------------------------
PHASE 3
INTERACTION FRAMEWORK
--------------------------------

Implement reusable:

interactable component/interface
interaction prompts
object highlighting
interaction detection
basic use action

Create test interactable objects.

--------------------------------
PHASE 4
PHYSICAL OBJECT HANDLING
--------------------------------

Implement:

pick up object
carry object
rotate object
drop object
place object

Make the system reusable.

--------------------------------
PHASE 5
CARD DATA SYSTEM
--------------------------------

Implement:

card data resource/schema
card database
set database
rarity definitions
variant definitions
sample test cards

Do NOT implement thousands of real cards.

Use sample data.

--------------------------------
PHASE 6
3D CARD RENDERING
--------------------------------

Implement:

physical card scene
front texture
back texture
correct proportions
inspection mode
rotation
zoom

Use placeholder card art.

--------------------------------
PHASE 7
FOIL SHADER
--------------------------------

Implement a polished reusable holographic card shader.

Include configurable:

foil mask
intensity
hue shift
sparkle
view angle response

Create several example foil presets.

--------------------------------
PHASE 8
BOOSTER GENERATION
--------------------------------

Implement:

booster product data
rarity tables
pack slots
random card generation
set association

No fancy opening animation yet.

--------------------------------
PHASE 9
PACK OPENING
--------------------------------

Implement the first polished pack-opening sequence.

Focus heavily on:

animation
camera framing
card reveal
rare-card presentation
new-card notification

--------------------------------
PHASE 10
PLAYER INVENTORY
--------------------------------

Implement inventory data for:

products
packs
cards
furniture

Keep physical objects and stored inventory clearly separated.

--------------------------------
PHASE 11
SHOP PRODUCTS
--------------------------------

Implement physical sealed products.

Allow products to be:

picked up
stored
stocked
identified

--------------------------------
PHASE 12
SHELVES
--------------------------------

Implement:

shelf slots
capacity
product assignment
manual stocking
visible product quantity

--------------------------------
PHASE 13
CUSTOMER FOUNDATION
--------------------------------

Implement:

customer spawning
navigation
entering shop
basic state machine
browsing
leaving

No purchasing yet.

--------------------------------
PHASE 14
CUSTOMER SHOPPING
--------------------------------

Implement:

customer preferences
product selection
budget
price checking
product pickup
checkout queue

--------------------------------
PHASE 15
CHECKOUT
--------------------------------

Implement:

register
transaction
payment
sale recording
customer departure

--------------------------------
PHASE 16
ECONOMY
--------------------------------

Implement:

money
expenses
sales
daily revenue
daily profit
financial tracking

--------------------------------
PHASE 17
PRODUCT ORDERING
--------------------------------

Implement:

supplier UI
ordering
order cost
delivery
incoming inventory

--------------------------------
PHASE 18
COLLECTION BINDER
--------------------------------

Implement:

binder interface
owned cards
missing cards
set completion
duplicate quantities
filters

--------------------------------
PHASE 19
FURNITURE PLACEMENT
--------------------------------

Implement:

placement preview
rotation
valid placement detection
purchasing furniture
moving furniture

--------------------------------
PHASE 20
STORE PROGRESSION
--------------------------------

Implement:

shop XP/reputation
upgrade requirements
new areas
larger store spaces
unlock system

--------------------------------
PHASE 21
SINGLE CARD SALES
--------------------------------

Implement:

single card display cases
card pricing
customer card inspection
single-card transactions

--------------------------------
PHASE 22
EMPLOYEES
--------------------------------

Implement initial employee framework.

Start with:

cashier
stocker

--------------------------------
PHASE 23
DAY SYSTEM
--------------------------------

Implement:

opening time
closing time
customer schedule
end-of-day summary

--------------------------------
PHASE 24
DYNAMIC CARD MARKET
--------------------------------

Implement an initial market fluctuation system.

Keep it understandable to the player.

--------------------------------
PHASE 25
ADVANCED CUSTOMERS
--------------------------------

Add different customer archetypes and improved behavior.

--------------------------------
PHASE 26
STORE REPUTATION
--------------------------------

Implement reputation factors and associated unlocks.

--------------------------------
PHASE 27
TOURNAMENTS
--------------------------------

Implement basic in-store tournament events.

Do not implement full Pokémon battles.

--------------------------------
PHASE 28
ADVANCED STORE CUSTOMIZATION
--------------------------------

Expand decoration, snapping, furniture categories, and visual customization.

--------------------------------
PHASE 29
VISUAL POLISH
--------------------------------

Improve:

lighting
materials
animations
particles
UI transitions
card effects
shop atmosphere

--------------------------------
PHASE 30
OPTIMIZATION AND RELEASE PREPARATION
--------------------------------

Profile the game.

Optimize expensive systems.

Clean warnings.

Improve accessibility/settings.

Perform save compatibility tests.

Perform regression testing.

==================================================
FIRST TASK
==================================================

Begin ONLY with PHASE 1: PROJECT FOUNDATION.

Before writing code:

1. Inspect the existing Godot project.
2. Identify its current Godot version.
3. Examine existing folders, scenes, scripts, autoloads, and project settings.
4. Preserve any useful existing work.
5. Briefly state what you intend to implement for Phase 1.

Then implement Phase 1.

Phase 1 should create a clean foundation for the rest of the project without implementing gameplay systems prematurely.

At minimum, Phase 1 should establish:

- organized project folders
- main game scene
- basic test environment
- project input actions needed for upcoming phases
- core autoload skeletons
- debug infrastructure
- save-system foundation
- basic game-state architecture if appropriate
- clean startup flow

Keep placeholder visuals simple.

Do not implement:

customers
cards
packs
shelves
economy gameplay
furniture placement
shop upgrades
employees
card collection
pack opening
foil shaders

Those belong to later phases.

When Phase 1 is complete, STOP.

Give me the Phase 1 completion report and testing instructions.

Do not begin Phase 2 until I tell you to continue.