(() => {
    const data = window.HOLON_SITE_DATA;
    const localeKeys = Object.keys(data.locales);
    const fallbackConverter = data.locales.en.converter;
    const KEY_MAPPING = {
        60: "Key1C",
        61: "Key1Csharp",
        62: "Key1D",
        63: "Key1Dsharp",
        64: "Key1E",
        65: "Key1F",
        66: "Key1Fsharp",
        67: "Key1G",
        68: "Key1Gsharp",
        69: "Key2A",
        70: "Key2Asharp",
        71: "Key2B",
        72: "Key2C",
        73: "Key2Csharp",
        74: "Key2D",
        75: "Key2Dsharp",
        76: "Key2E",
        77: "Key2F",
        78: "Key2Fsharp",
        79: "Key2G",
        80: "Key2Gsharp",
        81: "Key3A",
        82: "Key3Asharp",
        83: "Key3B",
        84: "Key3C"
    };

    const elements = {
        brandVersion: document.getElementById("brand-version"),
        localeLabel: document.getElementById("locale-label"),
        localeSelect: document.getElementById("locale-select"),
        heroEyebrow: document.getElementById("hero-eyebrow"),
        heroSubtitle: document.getElementById("hero-subtitle"),
        heroLead: document.getElementById("hero-lead"),
        ctaDiscord: document.getElementById("cta-discord"),
        ctaTikTok: document.getElementById("cta-tiktok"),
        ctaYouTube: document.getElementById("cta-youtube"),
        statsGrid: document.getElementById("stats-grid"),
        snapshotKicker: document.getElementById("snapshot-kicker"),
        snapshotTitle: document.getElementById("snapshot-title"),
        snapshotBody: document.getElementById("snapshot-body"),
        snapshotList: document.getElementById("snapshot-list"),
        sourcePills: document.getElementById("source-pills"),
        overviewKicker: document.getElementById("overview-kicker"),
        overviewTitle: document.getElementById("overview-title"),
        overviewBody: document.getElementById("overview-body"),
        detailList: document.getElementById("detail-list"),
        systemsKicker: document.getElementById("systems-kicker"),
        systemsTitle: document.getElementById("systems-title"),
        systemsBody: document.getElementById("systems-body"),
        systemsGrid: document.getElementById("systems-grid"),
        interfaceKicker: document.getElementById("interface-kicker"),
        interfaceTitle: document.getElementById("interface-title"),
        interfaceBody: document.getElementById("interface-body"),
        interfaceBadge: document.getElementById("interface-badge"),
        interfaceSource: document.getElementById("interface-source"),
        tabGrid: document.getElementById("tab-grid"),
        converterKicker: document.getElementById("converter-kicker"),
        converterTitle: document.getElementById("converter-title"),
        converterBody: document.getElementById("converter-body"),
        converterFileLabel: document.getElementById("converter-file-label"),
        converterIntervalLabel: document.getElementById("converter-interval-label"),
        converterModeLabel: document.getElementById("converter-mode-label"),
        converterHint: document.getElementById("converter-hint"),
        midiFile: document.getElementById("midi-file"),
        minInterval: document.getElementById("min-interval"),
        chordMode: document.getElementById("chord-mode"),
        convertMidi: document.getElementById("convert-midi"),
        downloadJson: document.getElementById("download-json"),
        converterStats: document.getElementById("converter-stats"),
        converterOutput: document.getElementById("converter-output"),
        languagesKicker: document.getElementById("languages-kicker"),
        languagesTitle: document.getElementById("languages-title"),
        languagesBody: document.getElementById("languages-body"),
        localeGrid: document.getElementById("locale-grid"),
        footerCopy: document.getElementById("footer-copy")
    };

    const metaDescription = document.querySelector('meta[name="description"]');

    let currentLocaleKey = "en";
    let currentLocale = data.locales.en;
    let converterResult = null;

    function normalizeLocale(input) {
        const raw = String(input || "").toLowerCase();
        const short = raw.split("-")[0];
        if (short === "jp") {
            return "ja";
        }
        return data.locales[short] ? short : "en";
    }

    function getInitialLocale() {
        const stored = normalizeLocale(window.localStorage.getItem("holon-hub-locale"));
        if (stored !== "en" || window.localStorage.getItem("holon-hub-locale")) {
            return stored;
        }
        return normalizeLocale(navigator.language || "en");
    }

    function clearNode(node) {
        while (node.firstChild) {
            node.removeChild(node.firstChild);
        }
    }

    function appendDetailRow(parent, label, value) {
        const wrapper = document.createElement("div");
        const dt = document.createElement("dt");
        const dd = document.createElement("dd");
        dt.textContent = label;
        dd.textContent = value;
        wrapper.append(dt, dd);
        parent.appendChild(wrapper);
    }

    function createTag(text, className) {
        const span = document.createElement("span");
        span.className = className;
        span.textContent = text;
        return span;
    }

    function getConverterCopy(locale) {
        return locale.converter || fallbackConverter;
    }

    function populateLocaleSelect() {
        clearNode(elements.localeSelect);

        localeKeys.forEach((key) => {
            const locale = data.locales[key];
            const option = document.createElement("option");
            option.value = key;
            option.textContent = `${locale.nativeName} (${locale.label})`;
            elements.localeSelect.appendChild(option);
        });
    }

    function renderStats(locale) {
        clearNode(elements.statsGrid);

        const stats = [
            { value: data.meta.version, label: locale.stats.build },
            { value: String(localeKeys.length), label: locale.stats.languages },
            { value: String(locale.tabs.length), label: locale.stats.tabs },
            { value: data.meta.featureGroups, label: locale.stats.groups }
        ];

        stats.forEach((item) => {
            const card = document.createElement("article");
            card.className = "stat-card";

            const value = document.createElement("span");
            value.className = "stat-value";
            value.textContent = item.value;

            const label = document.createElement("span");
            label.className = "stat-label";
            label.textContent = item.label;

            card.append(value, label);
            elements.statsGrid.appendChild(card);
        });
    }

    function renderSnapshot(locale) {
        clearNode(elements.snapshotList);
        clearNode(elements.sourcePills);

        const rows = [
            {
                label: locale.snapshot.labels.source,
                value: "hub-*.lua + orion.lua"
            },
            {
                label: locale.snapshot.labels.locale,
                value: locale.sourceFile
            },
            {
                label: locale.snapshot.labels.channels,
                value: "Discord / TikTok / YouTube"
            }
        ];

        rows.forEach((row) => appendDetailRow(elements.snapshotList, row.label, row.value));

        data.meta.sourceFiles.forEach((file) => {
            elements.sourcePills.appendChild(createTag(file, "file-pill"));
        });
    }

    function renderOverview(locale) {
        clearNode(elements.detailList);

        const details = [
            [locale.detailLabels.author, data.meta.author],
            [locale.detailLabels.roblox, data.meta.robloxId],
            [locale.detailLabels.foundation, data.meta.uiFoundation],
            [locale.detailLabels.notes, data.meta.notesFolder]
        ];

        details.forEach(([label, value]) => appendDetailRow(elements.detailList, label, value));
    }

    function renderSystems(locale) {
        clearNode(elements.systemsGrid);

        data.meta.systemDefinitions.forEach((system) => {
            const copy = locale.modules[system.key];
            const card = document.createElement("article");
            card.className = "system-card";

            const title = document.createElement("h3");
            title.className = "system-title";
            title.textContent = copy.title;

            const body = document.createElement("p");
            body.className = "system-body";
            body.textContent = copy.text;

            const tagRow = document.createElement("div");
            tagRow.className = "tag-row";
            system.tags.forEach((tag) => {
                tagRow.appendChild(createTag(tag, "tag"));
            });

            card.append(title, body, tagRow);
            elements.systemsGrid.appendChild(card);
        });
    }

    function renderTabs(locale) {
        clearNode(elements.tabGrid);
        elements.interfaceSource.textContent = locale.sourceFile;

        locale.tabs.forEach((tab, index) => {
            const card = document.createElement("article");
            card.className = "tab-card";

            const badge = document.createElement("span");
            badge.className = "tab-index";
            badge.textContent = `${String(index + 1).padStart(2, "0")}`;

            const name = document.createElement("div");
            name.className = "tab-name";
            name.textContent = tab;

            card.append(badge, name);
            elements.tabGrid.appendChild(card);
        });
    }

    function renderLocaleCards(activeKey, locale) {
        clearNode(elements.localeGrid);

        localeKeys.forEach((key) => {
            const entry = data.locales[key];
            const button = document.createElement("button");
            button.type = "button";
            button.className = "locale-card";
            if (key === activeKey) {
                button.classList.add("is-active");
            }
            button.setAttribute("aria-pressed", String(key === activeKey));
            button.addEventListener("click", () => setLocale(key));

            const head = document.createElement("div");
            head.className = "locale-head";

            const name = document.createElement("div");
            name.className = "locale-name";
            name.textContent = entry.nativeName;

            const source = document.createElement("div");
            source.className = "locale-source";
            source.textContent = entry.sourceFile;

            head.append(name, source);

            const tabs = document.createElement("div");
            tabs.className = "locale-tabs";
            entry.tabs.slice(0, 4).forEach((tab) => {
                tabs.appendChild(createTag(tab, "locale-tab-pill"));
            });

            const action = document.createElement("div");
            action.className = "locale-action";
            action.textContent = locale.languages.switchLabel;

            button.append(head, tabs, action);
            elements.localeGrid.appendChild(button);
        });
    }

    function renderNavigation(locale) {
        document.querySelectorAll("[data-nav]").forEach((link) => {
            const key = link.getAttribute("data-nav");
            link.textContent = locale.nav[key];
        });
    }

    function formatSeconds(value) {
        return `${Number(value || 0).toFixed(3)}s`;
    }

    function renderConverter(locale) {
        const copy = getConverterCopy(locale);
        elements.converterKicker.textContent = copy.kicker;
        elements.converterTitle.textContent = copy.title;
        elements.converterBody.textContent = copy.body;
        elements.converterFileLabel.textContent = copy.fileLabel;
        elements.converterIntervalLabel.textContent = copy.intervalLabel;
        elements.converterModeLabel.textContent = copy.modeLabel;
        elements.converterHint.textContent = copy.hint;
        elements.convertMidi.textContent = copy.convert;
        elements.downloadJson.textContent = copy.download;

        if (!converterResult) {
            clearNode(elements.converterStats);
            elements.converterOutput.textContent = copy.empty;
            elements.downloadJson.disabled = true;
            return;
        }

        clearNode(elements.converterStats);
        appendDetailRow(elements.converterStats, copy.stats.file, converterResult.fileName);
        appendDetailRow(elements.converterStats, copy.stats.detected, String(converterResult.detectedCount));
        appendDetailRow(elements.converterStats, copy.stats.reduced, String(converterResult.reducedCount));
        appendDetailRow(elements.converterStats, copy.stats.filtered, String(converterResult.filteredCount));
        appendDetailRow(elements.converterStats, copy.stats.duration, formatSeconds(converterResult.totalDuration));
        appendDetailRow(elements.converterStats, copy.stats.output, String(converterResult.output.length));
        elements.converterOutput.textContent = JSON.stringify(converterResult.output, null, 2);
        elements.downloadJson.disabled = false;
    }

    function setLocale(localeKey) {
        const key = data.locales[localeKey] ? localeKey : "en";
        const locale = data.locales[key];
        currentLocaleKey = key;
        currentLocale = locale;

        window.localStorage.setItem("holon-hub-locale", key);
        document.documentElement.lang = locale.langTag;
        document.documentElement.dir = locale.dir;
        document.body.dataset.locale = key;

        document.title = `${data.meta.brand} | ${locale.hero.subtitle}`;
        if (metaDescription) {
            metaDescription.setAttribute("content", locale.hero.lead);
        }

        elements.brandVersion.textContent = data.meta.version;
        elements.localeLabel.textContent = locale.localeLabel;
        elements.localeSelect.setAttribute("aria-label", locale.localeLabel);
        elements.localeSelect.value = key;

        renderNavigation(locale);

        elements.heroEyebrow.textContent = locale.hero.eyebrow;
        elements.heroSubtitle.textContent = locale.hero.subtitle;
        elements.heroLead.textContent = locale.hero.lead;

        elements.ctaDiscord.href = data.meta.links.discord;
        elements.ctaTikTok.href = data.meta.links.tiktok;
        elements.ctaYouTube.href = data.meta.links.youtube;
        elements.ctaDiscord.textContent = locale.cta.discord;
        elements.ctaTikTok.textContent = locale.cta.tiktok;
        elements.ctaYouTube.textContent = locale.cta.youtube;

        elements.snapshotKicker.textContent = locale.snapshot.kicker;
        elements.snapshotTitle.textContent = locale.snapshot.title;
        elements.snapshotBody.textContent = locale.snapshot.body;

        elements.overviewKicker.textContent = locale.overview.kicker;
        elements.overviewTitle.textContent = locale.overview.title;
        elements.overviewBody.textContent = locale.overview.body;

        elements.systemsKicker.textContent = locale.systems.kicker;
        elements.systemsTitle.textContent = locale.systems.title;
        elements.systemsBody.textContent = locale.systems.body;

        elements.interfaceKicker.textContent = locale.interface.kicker;
        elements.interfaceTitle.textContent = locale.interface.title;
        elements.interfaceBody.textContent = locale.interface.body;
        elements.interfaceBadge.textContent = locale.interface.badge;

        elements.languagesKicker.textContent = locale.languages.kicker;
        elements.languagesTitle.textContent = locale.languages.title;
        elements.languagesBody.textContent = locale.languages.body;

        elements.footerCopy.textContent = locale.footer;

        renderStats(locale);
        renderSnapshot(locale);
        renderOverview(locale);
        renderSystems(locale);
        renderTabs(locale);
        renderConverter(locale);
        renderLocaleCards(key, locale);
    }

    function setupReveal() {
        const revealNodes = document.querySelectorAll(".reveal");
        if (!("IntersectionObserver" in window)) {
            revealNodes.forEach((node) => node.classList.add("is-visible"));
            return;
        }

        const observer = new IntersectionObserver(
            (entries) => {
                entries.forEach((entry) => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add("is-visible");
                        observer.unobserve(entry.target);
                    }
                });
            },
            {
                threshold: 0.14
            }
        );

        revealNodes.forEach((node) => observer.observe(node));
    }

    function readUint32(view, offset) {
        return view.getUint32(offset, false);
    }

    function readUint16(view, offset) {
        return view.getUint16(offset, false);
    }

    function readVarLen(view, start) {
        let value = 0;
        let offset = start;
        let byte = 0;
        do {
            if (offset >= view.byteLength) {
                throw new Error("Unexpected end of MIDI data");
            }
            byte = view.getUint8(offset);
            value = (value << 7) | (byte & 0x7f);
            offset += 1;
        } while (byte & 0x80);
        return { value, offset };
    }

    function parseMidi(arrayBuffer) {
        const view = new DataView(arrayBuffer);
        let offset = 0;

        function readChunk() {
            if (offset + 8 > view.byteLength) {
                throw new Error("Invalid MIDI chunk");
            }
            const id = String.fromCharCode(
                view.getUint8(offset),
                view.getUint8(offset + 1),
                view.getUint8(offset + 2),
                view.getUint8(offset + 3)
            );
            const length = readUint32(view, offset + 4);
            const start = offset + 8;
            const end = start + length;
            if (end > view.byteLength) {
                throw new Error("Truncated MIDI chunk");
            }
            offset = end;
            return { id, start, end, length };
        }

        const header = readChunk();
        if (header.id !== "MThd" || header.length < 6) {
            throw new Error("Missing MThd header");
        }

        const format = readUint16(view, header.start);
        const trackCount = readUint16(view, header.start + 2);
        const division = readUint16(view, header.start + 4);
        if (division & 0x8000) {
            throw new Error("SMPTE time division is not supported");
        }
        const ticksPerBeat = division;

        const noteEvents = [];
        const tempoEvents = [{ tick: 0, tempo: 500000 }];

        for (let trackIndex = 0; trackIndex < trackCount; trackIndex += 1) {
            const chunk = readChunk();
            if (chunk.id !== "MTrk") {
                continue;
            }

            let trackOffset = chunk.start;
            let absoluteTick = 0;
            let runningStatus = null;

            while (trackOffset < chunk.end) {
                const delta = readVarLen(view, trackOffset);
                absoluteTick += delta.value;
                trackOffset = delta.offset;

                if (trackOffset >= chunk.end) {
                    break;
                }

                let statusByte = view.getUint8(trackOffset);
                if (statusByte < 0x80) {
                    if (runningStatus === null) {
                        throw new Error("Running status without previous status");
                    }
                    statusByte = runningStatus;
                } else {
                    trackOffset += 1;
                    runningStatus = statusByte;
                }

                if (statusByte === 0xff) {
                    if (trackOffset >= chunk.end) {
                        break;
                    }
                    const metaType = view.getUint8(trackOffset);
                    trackOffset += 1;
                    const metaLength = readVarLen(view, trackOffset);
                    trackOffset = metaLength.offset;
                    if (metaType === 0x51 && metaLength.value === 3) {
                        const tempo = (view.getUint8(trackOffset) << 16)
                            | (view.getUint8(trackOffset + 1) << 8)
                            | view.getUint8(trackOffset + 2);
                        tempoEvents.push({ tick: absoluteTick, tempo });
                    }
                    trackOffset += metaLength.value;
                    continue;
                }

                if (statusByte === 0xf0 || statusByte === 0xf7) {
                    const sysExLength = readVarLen(view, trackOffset);
                    trackOffset = sysExLength.offset + sysExLength.value;
                    continue;
                }

                const messageType = statusByte & 0xf0;
                const dataLength = messageType === 0xc0 || messageType === 0xd0 ? 1 : 2;
                const data1 = view.getUint8(trackOffset);
                const data2 = dataLength === 2 ? view.getUint8(trackOffset + 1) : 0;
                trackOffset += dataLength;

                if (messageType === 0x90 && data2 > 0 && KEY_MAPPING[data1]) {
                    noteEvents.push({
                        tick: absoluteTick,
                        note: data1,
                        velocity: data2,
                        key: KEY_MAPPING[data1]
                    });
                }
            }
        }

        tempoEvents.sort((a, b) => a.tick - b.tick || a.tempo - b.tempo);
        noteEvents.sort((a, b) => a.tick - b.tick || a.note - b.note);

        return {
            format,
            ticksPerBeat,
            tempoEvents,
            noteEvents
        };
    }

    function createTickToSecondConverter(ticksPerBeat, tempoEvents) {
        const events = [];
        let lastTick = 0;
        let lastSeconds = 0;
        let currentTempo = 500000;

        tempoEvents.forEach((event, index) => {
            if (index === 0 && event.tick === 0) {
                currentTempo = event.tempo;
                events.push({ tick: 0, seconds: 0, tempo: currentTempo });
                return;
            }

            if (event.tick < lastTick) {
                return;
            }

            lastSeconds += ((event.tick - lastTick) * currentTempo) / 1000000 / ticksPerBeat;
            lastTick = event.tick;
            currentTempo = event.tempo;
            events.push({ tick: event.tick, seconds: lastSeconds, tempo: currentTempo });
        });

        if (!events.length) {
            events.push({ tick: 0, seconds: 0, tempo: 500000 });
        }

        return (tick) => {
            let active = events[0];
            for (let i = 1; i < events.length; i += 1) {
                if (events[i].tick > tick) {
                    break;
                }
                active = events[i];
            }
            return active.seconds + ((tick - active.tick) * active.tempo) / 1000000 / ticksPerBeat;
        };
    }

    function convertMidiToHolonJson(arrayBuffer, options) {
        const parsed = parseMidi(arrayBuffer);
        const tickToSecond = createTickToSecondConverter(parsed.ticksPerBeat, parsed.tempoEvents);
        const detected = parsed.noteEvents.map((event) => ({
            key: event.key,
            note: event.note,
            velocity: event.velocity,
            time: tickToSecond(event.tick)
        })).sort((a, b) => a.time - b.time || a.note - b.note);

        const reduced = [];
        let index = 0;
        while (index < detected.length) {
            const currentTime = detected[index].time;
            const chordNotes = [];

            while (index < detected.length && Math.abs(detected[index].time - currentTime) < 0.01) {
                chordNotes.push(detected[index]);
                index += 1;
            }

            const selected = options.chordMode === "lowest"
                ? chordNotes.reduce((lowest, note) => (note.note < lowest.note ? note : lowest))
                : chordNotes.reduce((highest, note) => (note.note > highest.note ? note : highest));

            reduced.push({
                key: selected.key,
                time: currentTime
            });
        }

        const filtered = [];
        let lastTime = -options.minInterval;
        reduced.forEach((note) => {
            if (note.time - lastTime >= options.minInterval) {
                filtered.push(note);
                lastTime = note.time;
            }
        });

        const output = [];
        let previousTime = 0;
        filtered.forEach((note) => {
            const delay = Number((note.time - previousTime).toFixed(6));
            output.push({
                key: note.key,
                delay
            });
            previousTime = note.time;
        });

        return {
            detectedCount: detected.length,
            reducedCount: reduced.length,
            filteredCount: filtered.length,
            totalDuration: filtered.length ? filtered[filtered.length - 1].time : 0,
            output
        };
    }

    async function handleMidiConvert() {
        const copy = getConverterCopy(currentLocale);
        const file = elements.midiFile.files && elements.midiFile.files[0];
        if (!file) {
            clearNode(elements.converterStats);
            elements.converterOutput.textContent = copy.selectFile;
            elements.downloadJson.disabled = true;
            return;
        }

        try {
            const minInterval = Math.max(0, Number(elements.minInterval.value || 0.05));
            const chordMode = elements.chordMode.value === "lowest" ? "lowest" : "highest";
            const buffer = await file.arrayBuffer();
            const result = convertMidiToHolonJson(buffer, { minInterval, chordMode });
            converterResult = {
                ...result,
                fileName: file.name
            };
            renderConverter(currentLocale);
        } catch (_error) {
            converterResult = null;
            clearNode(elements.converterStats);
            elements.converterOutput.textContent = copy.invalidMidi;
            elements.downloadJson.disabled = true;
        }
    }

    function handleJsonDownload() {
        if (!converterResult) {
            return;
        }
        const copy = getConverterCopy(currentLocale);
        const blob = new Blob([JSON.stringify(converterResult.output, null, 2)], {
            type: "application/json"
        });
        const link = document.createElement("a");
        link.href = URL.createObjectURL(blob);
        link.download = copy.downloadName;
        document.body.appendChild(link);
        link.click();
        link.remove();
        setTimeout(() => URL.revokeObjectURL(link.href), 1000);
    }

    populateLocaleSelect();
    setupReveal();

    elements.localeSelect.addEventListener("change", (event) => {
        setLocale(event.target.value);
    });

    elements.convertMidi.addEventListener("click", handleMidiConvert);
    elements.downloadJson.addEventListener("click", handleJsonDownload);

    setLocale(getInitialLocale());
})();
