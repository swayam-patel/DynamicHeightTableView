# UITableView Demos

Two common but often-misunderstood UITableView patterns in one app — dynamic height cells that grow with their content, and expandable cells that reveal hidden content on tap.

Both are implemented with `UITableView.automaticDimension`, XIB-based custom cells, and zero third-party dependencies.

<!-- --- -->

<!-- ## Screenshot / Demo -->

<!-- Add a screen recording or screenshot here -->
<!-- > 📸 _Drop a GIF or screenshot here — showing both the dynamic height cells and the expand/collapse animation with the rotating chevron._ -->

---

## What's Covered

| Demo | Key concept |
|------|-------------|
| Dynamic Height | `automaticDimension` + `numberOfLines = 0` |
| Expandable (Single) | One cell open at a time — auto-collapses previous |
| Expandable (Multiple) | Any number of cells open simultaneously |
| Chevron | Animated rotation on expand/collapse |
| Mode switching | `UIMenu` in the nav bar to toggle between modes |

---

## Demo 1 — Dynamic Height Cells

The simplest self-sizing cell setup. The cell grows vertically to fit whatever text you give it — no manual height calculation, no `heightForRowAt`.

### The two lines that make it work

```swift
tableView.rowHeight = UITableView.automaticDimension
tableView.estimatedRowHeight = 100
```

`automaticDimension` tells UIKit to calculate row height from Auto Layout constraints. `estimatedRowHeight` is a performance hint — UIKit uses it to estimate scroll indicators and offscreen cell sizes before they're rendered. Set it close to your average row height.

### The cell

```swift
class DynamicHeightTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabel.numberOfLines = 0  // this is the key — unlimited lines
        contentLabel.font = .systemFont(ofSize: 16)
    }

    func configure(with text: String) {
        contentLabel.text = text
    }
}
```

`numberOfLines = 0` lets the label grow to as many lines as needed. Combined with Auto Layout constraints that pin the label to all four edges of `contentView`, UIKit can derive the cell height automatically.

### In the XIB

The label must be pinned to `contentView` on all sides with some padding. Without a bottom constraint, UIKit can't determine the cell height and will fall back to the estimated value.

```
contentView
  └── contentLabel (top: 8, bottom: 8, leading: 16, trailing: 16)
```

---

## Demo 2 — Expandable Cells

Cells that show a title row and reveal a content block when tapped. Supports two modes: **Single** (only one cell open at a time) and **Multiple** (any number open simultaneously), switchable from a nav bar menu.

### Tracking expanded state

```swift
var expandedIndexPaths: Set<IndexPath> = []
var expansionMode: ExpansionMode = .single  // resets on each push — intentional for demo
```

`Set<IndexPath>` is the right data structure here — O(1) insert, remove, and membership check, and no duplicates.

### Single mode — tap handling

```swift
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    var rowsToReload: [IndexPath] = []

    // Collapse the previously expanded cell (if any)
    if let prevIndex = expandedIndexPaths.first, prevIndex != indexPath {
        expandedIndexPaths.remove(prevIndex)
        rowsToReload.append(prevIndex)
    }

    // Toggle the tapped cell
    if expandedIndexPaths.contains(indexPath) {
        expandedIndexPaths.remove(indexPath)
    } else {
        expandedIndexPaths.insert(indexPath)
    }
    rowsToReload.append(indexPath)

    // Animate both collapse and expand in one transaction
    tableView.beginUpdates()
    tableView.reloadRows(at: rowsToReload, with: .automatic)
    tableView.endUpdates()
}
```

Collapsing the previous cell and expanding the new one in a single `beginUpdates`/`endUpdates` block is important — it animates both changes simultaneously instead of two separate jumps.

### Multiple mode — tap handling

```swift
// Just toggle the tapped cell, no need to touch any other rows
if expandedIndexPaths.contains(indexPath) {
    expandedIndexPaths.remove(indexPath)
} else {
    expandedIndexPaths.insert(indexPath)
}

tableView.beginUpdates()
tableView.reloadRows(at: [indexPath], with: .automatic)
tableView.endUpdates()
```

### The cell

```swift
func configure(title: String, content: String, isExpanded: Bool) {
    titleLabel.text = title
    contentLabel.text = content
    contentLabel.isHidden = !isExpanded

    // Animated chevron rotation
    UIView.animate(withDuration: 0.2) {
        self.chevronImageView.transform = isExpanded
            ? CGAffineTransform(rotationAngle: .pi)  // points up when expanded
            : .identity                               // points down when collapsed
    }
}
```

Hiding `contentLabel` shrinks the `UIStackView` it lives in, which reduces the cell's Auto Layout height — that's what drives the collapse animation. No `heightForRowAt` needed.

### Switching modes

```swift
private func setExpansionMode(_ mode: ExpansionMode) {
    expansionMode = mode
    let previouslyExpanded = expandedIndexPaths
    expandedIndexPaths.removeAll()

    UIView.animate(withDuration: 0.3) {
        self.tableView.reloadRows(at: Array(previouslyExpanded), with: .none)
        self.tableView.layoutIfNeeded()
    }
}
```

Switching modes collapses all currently open cells at once. Snapshotting `expandedIndexPaths` before clearing it is necessary — you need the old indices to know which rows to reload.

---

## Key Concepts

**Why `beginUpdates` / `endUpdates`?**
Wrapping row reloads in these tells UIKit to animate all the changes as one batch. Without them, each `reloadRows` call triggers a separate layout pass and the animation looks choppy.

**Why `Set<IndexPath>` instead of `[IndexPath]`?**
Sets give you O(1) `contains` and `remove`. Since `didSelectRowAt` fires on every tap, keeping this fast matters — with an array you'd be doing O(n) lookups on every tap.

**Why hide the label instead of removing it?**
The `UIStackView` automatically reclaims space when a subview is hidden (`isHidden = true`). This is cleaner than manually toggling constraints or adjusting heights — the stack view handles the layout math.

---

## Adapting It For Your Own Project

### Use your own data model

```swift
struct FAQItem {
    let question: String
    let answer: String
}

let data: [FAQItem] = [
    FAQItem(question: "What is your return policy?", answer: "We offer 30-day returns..."),
    FAQItem(question: "Do you ship internationally?", answer: "Yes, we ship to over 50 countries...")
]
```

### Start with a cell pre-expanded

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    // Expand the first cell on launch
    expandedIndexPaths.insert(IndexPath(row: 0, section: 0))
}
```

### Default to Multiple mode

```swift
var expansionMode: ExpansionMode = .multiple
```

---

## Requirements

| | |
|---|---|
| Language | Swift 5+ |
| Platform | iOS 14+ |
| Frameworks | `UIKit` |
| Dependencies | None |
| Tools | Xcode 13+ |

iOS 14+ is required for `UIAction` and `UIMenu` used in the mode switcher. The dynamic height and expandable demos themselves work on iOS 13+.

---

## Getting Started

```bash
git clone https://github.com/swayam-patel/DynamicHeightTableView.git
```

Open `DynamicHeightTableView.xcodeproj` in Xcode and run on a simulator or device. The main screen shows two buttons — one for each demo. In the Expandable demo, tap the `⋯` button in the top right to switch between Single and Multiple expansion modes.
