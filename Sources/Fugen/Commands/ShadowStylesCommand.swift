import Foundation
import SwiftCLI
import PromiseKit

final class ShadowStylesCommand: AsyncExecutableCommand, GenerationConfigurableCommand {

    // MARK: - Instance Properties

    let generator: ShadowStylesGenerator

    // MARK: -

    let name = "shadowStyles"
    let shortDescription = "Generates code for shadow styles from a Figma file."

    let fileKey = Key<String>(
        "--fileKey",
        description: """
            Figma file key to generate shadow styles from.
            """
    )

    let fileVersion = Key<String>(
        "--fileVersion",
        description: """
            Figma file version ID to generate shadow styles from.
            """
    )

    let includedNodes = VariadicKey<String>(
        "--includingNodes",
        "-i",
        description: #"""
            A list of Figma nodes whose styles will be extracted.
            Can be repeated multiple times and must be in the format: -i "1:23".
            If omitted, all nodes will be included.
            """#
    )

    let excludedNodes = VariadicKey<String>(
        "--excludingNodes",
        "-e",
        description: #"""
            A list of Figma nodes whose styles will be ignored.
            Can be repeated multiple times and must be in the format: -e "1:23".
            """#
    )

    let accessToken = Key<String>(
        "--accessToken",
        description: """
            A personal access token to make requests to the Figma API.
            Get more info: https://www.figma.com/developers/api#access-tokens
            """
    )

    let template = Key<String>(
        "--template",
        "-t",
        description: """
            Path to the template file.
            If no template is passed a default template will be used.
            """
    )

    let templateOptions = VariadicKey<String>(
        "--options",
        "-o",
        description: #"""
            An option that will be merged with template context, and overwrite any values of the same name.
            Can be repeated multiple times and must be in the format: -o "name:value".
            """#
    )

    let destination = Key<String>(
        "--destination",
        "-d",
        description: """
            The path to the file to generate.
            By default, generated code will be printed on stdout.
            """
    )

    // MARK: - Initializers

    init(generator: ShadowStylesGenerator) {
        self.generator = generator
    }

    // MARK: - Instance Methods

    func executeAsyncAndExit() throws {
        firstly {
            self.generator.generate(configuration: self.generationConfiguration)
        }.done {
            self.succeed(message: "Shadow styles generated successfully!")
        }.catch { error in
            self.fail(message: "Failed to generate shadow styles: \(error)")
        }
    }
}
