//
//  GetFitWidget.swift
//  GetFit
//
//  Created by Justin Maloney on 12/09/20.
//  Copyright © 2020 Justin Maloney. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    //func to return place holder data set, used for displaying while loading data
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), photo: "Quote1")
    }

    //func to get sample dataset for displaying example of widget to add to homescreen
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), photo: "Quote1")
        completion(entry)
    }

    //func to set data timeline for setting poster order and time to display which poster
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = [] //array of entries to supply data to each timeline entry
        
        // poster filenames
        let photos = ["Quote1", "Quote2", "Quote3", "Quote4", "Quote5", "Quote6"]

        // Generate a timeline consisting of five entries an minute apart, starting from the current date.
        let currentDate = Date()
        for minuteOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            //add photo name to each entry
            let entry = SimpleEntry(date: entryDate, photo: photos[minuteOffset])
            entries.append(entry)
        }
        
        //set timeline to reload data at the end of poster cycle
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

//data set struct to hold data needed for view
struct SimpleEntry: TimelineEntry {
    let date: Date
    let photo: String
}

//view to display motivational poster
struct GetFitWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
            Image(entry.photo)
                .resizable()
    }
}

@main
struct GetFitWidget: Widget {
    let kind: String = "GetFitWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            GetFitWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct GetFitWidget_Previews: PreviewProvider {
    static var previews: some View {
        GetFitWidgetEntryView(entry: SimpleEntry(date: Date(), photo: "ImageUnavailable"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
