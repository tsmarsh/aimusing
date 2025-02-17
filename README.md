# AIMusing

AIMusing is an AI-assisted novel-writing application built on **meshobj**, designed to dynamically respond to narrative changes, track character development, and maintain structured storytelling elements.

## Features
- **Restlette / Graphlette API**: Provides structured storage and retrieval of story elements.
- **Event-Driven Workflow**: Automatically processes changes in the story world, propagating them through AI-assisted refinements.
- **AI Agents**:
  - **Checkers**: Validate narrative consistency, style, and plot.
  - **Specialists**: Generate and refine content for specific aspects of the story.
  - **Superego**: Curates ideas, selects the best ones, and delegates execution.
- **Version Control**: All story elements support time-travel queries using `at` parameters.

## Architecture
AIMusing is structured as follows:

```mermaid
classDiagram

    Work *-- Chapter
    class Work {
        title: String! [faker: "book.title"]
        genre: String [faker: "book.genre"]
        author: String [faker: "book.author"]
        style_id: Style
        timeline_id: Timeline

        getByTitle(title: String): Work
        getByAuthor(name: String): [Work]
    }

    Chapter *-- Scene
    class Chapter {
        title: String!
        order: Int [minimum: 0]
        work_id: Work

        getByTitle(title: String): [Chapter]
    }

    Character *-- CharacterEvent
    Character *-- CharacterNote
    class Character {
        name: String! [faker: "person.fullName"]
        role: String [faker: "person.jobtype"]
        archetype: String
        description: String [faker: "person.bio"]

        getByName(name: String): [Character]
    }

    class CharacterNote {
        character_id: Character
        keywords: [String] [faker: "word.adjective"]
        note: String!

        getByKeywords(keywords: [String]): [CharacterNote]

    }

    class CharacterEvent {
        event_id: Event!
        character_id: Character!
    }

    Location *-- Event
    class Location {
        name: String!
        description: String
        keywords: [String] [faker: "word.adjective"]

        getByKeywords(keywords: [String]): [CharacterNote]
        getByName(name: String): [Location]
    }

    Plot *-- Work
    class Plot {
        name: String!
        description: String
        structure: String
    }

    Style *-- Work
    Style *-- Scene
    class Style {
        tone: String
        voice: String
        literaryInfluences: [String]
        pacing: String
    }
    
    Event *-- CharacterEvent
    Event *-- SceneEvent
    class Event {
        name: String!
        description: String
        eventDate: Date
        type: String
        timeline_id: Timeline
        location_id: Location

        getByName(name: String): Event
    }

    class SceneEvent {
        event_id: Event
        chapter_id: Chapter
    }

    Scene *-- SceneEvent
    class Scene {
        title: String!
        summary: String
        location: String
        characters: [Character]
        chapter_id: Chapter

        getByTitle(title: String): Scene
    }

    Timeline *-- Event
    Timeline *-- Work
    class Timeline {
        name: String!

        getByName(name: String): Timeline
    }
```

## Getting Started
### Prerequisites
- **Docker** (for containerized execution)
- **Node.js / Yarn** (for running the API)
- **Kafka & Debezium** (for event streaming and CDC processing)

### Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/tsmarsh/aimusing.git
   cd aimusing
   ```
2. Install dependencies:
   ```sh
   yarn install
   ```
3. Start the development environment:
   ```sh
   docker-compose up
   ```

## Usage
AIMusing runs as an event-driven system where each **Restlette update** triggers AI processing:
1. **Create a Work**:
   ```sh
   curl -X POST http://localhost:3000/work -d '{"title": "My Novel"}'
   ```
2. **Add a Character**:
   ```sh
   curl -X POST http://localhost:3000/character -d '{"name": "Alice", "role": "Protagonist"}'
   ```
3. **Modify a Scene** → Changes automatically trigger AI agents for validation & refinement.

## Roadmap
- [ ] **Integrate AI Agents** (Checkers, Specialists, Superego)
- [ ] **Implement Event Workflow** (CDC → Debezium → Kafka → Vector Store)
- [ ] **Build an Interactive UI** for writers
- [ ] **Enhance AI Narrative Generation**

## License
This project is licensed under the MIT License.

## Contributions
Contributions are welcome! Open an issue or submit a pull request to get involved.
