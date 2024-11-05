//
//  RegistrationAccessibilityTests.swift
//  BeautifyMeUITests
//
//  Created by Cristian Caro on 4/11/24.
//

import XCTest
@testable import BeautifyMe

final class RegistrationAccessibilityTests: XCTestCase {
    var app: XCUIApplication!
    var verificationViewModel: VerificationViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false
        app = XCUIApplication()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app.launch() // Launches on LogIn
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        verificationViewModel = nil
    }
    
    
    func test_LogIn_Accessibility_Labels(){
        // Every element has an accessibilityLabel
        XCTAssertTrue(app.staticTexts["Welcome back message"].exists, "El mensaje de bienvenida no tiene un accessibility label adecuado.")
        XCTAssertTrue(app.staticTexts["Login prompt message"].exists, "El mensaje de bienvenida no tiene un accessibility label adecuado.")
        XCTAssertTrue(app.textFields["Email input field"].exists, "El campo de email no tiene un accessibility label adecuado.")
        XCTAssertTrue(app.secureTextFields["Password input field"].exists, "El campo de contraseña no tiene un accessibility label adecuado.")
        XCTAssertTrue(app.buttons["Forgot password link"].exists, "El link de Forgot password no tiene un accessibility label adecuado.")
        XCTAssertTrue(app.buttons["Log In button"].exists, "El botón Log In no tiene un accessibility label adecuado.")
        XCTAssertTrue(app.buttons["Log In with Google button"].exists, "El botón Log In with Google no tiene un accessibility label adecuado.")
        XCTAssertTrue(app.buttons["Join Now link"].exists, "El botón Join Now no tiene un accessibility label adecuado.")
    }
    func test_LogIn_Accessibility_Values(){
        // Every element has an accessibilityValue element
        XCTAssertEqual(app.textFields["Email input field"].value as? String, "Empty", "El valor de accesibilidad del campo de email debe ser Empty.")
        XCTAssertEqual(app.secureTextFields["Password input field"].value as? String, "Empty", "El valor de accesibilidad del campo de contraseña debe ser Empty.")
        
        if app.staticTexts["Email error message"].exists {
            XCTAssertEqual(app.staticTexts["Email error message"].label, "Email error", "El mensaje de error de email no es el correcto.")
        }
        
        if app.staticTexts["Password error message"].exists {
            XCTAssertEqual(app.staticTexts["Password error message"].label, "Password error", "El mensaje de error de contraseña no es el correcto.")
        }
        
        if app.staticTexts["Error message"].exists {
            XCTAssertEqual(app.staticTexts["Error message"].label, "Message error", "El mensaje de error general no es el correcto.")
        }
    }
    func test_SignIn_Accessibility_Labels(){
        // Every element has an accessibilityLabel
        XCTAssertTrue(app.staticTexts["Create an account title"].exists, "El título de la vista no tiene label.")
        XCTAssertTrue(app.staticTexts["Subtitle: Please type full information below and we can create your account."].exists, "El subtítulo de la vista no tiene label.")
        XCTAssertTrue(app.textFields["Name input field"].exists, "El campo de texto para nombre no tiene label.")
        XCTAssertTrue(app.textFields["Email input field"].exists, "El campo de texto para email no tiene label.")
        XCTAssertTrue(app.textFields["Phone number input field"].exists, "El campo de texto para número de teléfono no tiene label.")
        XCTAssertTrue(app.secureTextFields["Password input field"].exists, "El campo de texto para contraseña no tiene label.")
        XCTAssertTrue(app.buttons["Join Now button"].exists, "El botón Join Now no tiene label.")
        XCTAssertTrue(app.buttons["Join with Google button"].exists, "El botón Join with Google no tiene label.")
        XCTAssertTrue(app.buttons["Log In button"].exists, "El botón Log In no tiene label.")
    }
    
    func test_SignIn_Accessibility_Values() {
        // Every element has an accessibilityValue element
        XCTAssertEqual(app.textFields["Name input field"].value as? String, "Empty", "El valor de accesibilidad del campo de nombre debe ser Empty")
        XCTAssertEqual(app.textFields["Email input field"].value as? String, "Empty", "El valor de accesibilidad del campo de email debe ser Empty")
        XCTAssertEqual(app.textFields["Phone number input field"].value as? String, "Empty", "El valor de accesibilidad del campo de teléfono debe ser Empty")
        XCTAssertEqual(app.secureTextFields["Password input field"].value as? String, "Empty", "El valor de accesibilidad del campo de contraseña debe ser Empty")
    }
    func test_ForgotPassword_Accessibility_Labels(){
        let title = app.staticTexts["Forgot Password,"]
        XCTAssertTrue(title.exists, "The title 'Forgot Password,' should exist.")
        
        let subtitle = app.staticTexts["Please type your email below and we will give you a OTP code."]
        XCTAssertTrue(subtitle.exists, "The subtitle should exist.")
        
        let emailTextField = app.textFields["Email Address"]
        XCTAssertTrue(emailTextField.exists, "The email text field should exist.")
        
        let phoneTextField = app.textFields["Phone Number"]
        XCTAssertTrue(phoneTextField.exists, "The phone number text field should exist.")
        
        let sendCodeButton = app.buttons["Send Code"]
        XCTAssertTrue(sendCodeButton.exists, "The 'Send Code' button should exist.")
    }
    func test_ForgotPassword_Accessibility_Values(){
        let emailTextField = app.textFields["Email Address"]
        XCTAssertTrue(emailTextField.isHittable, "The email text field should be hittable.")
        
        let phoneTextField = app.textFields["Phone Number"]
        XCTAssertTrue(phoneTextField.isHittable, "The phone number text field should be hittable.")
        let sendCodeButton = app.buttons["Send Code"]
        XCTAssertTrue(sendCodeButton.isHittable, "The 'Send Code' button should be hittable.")
    }
    
    func test_ForgotPassword_Toggle_Accessibility() {
        // Toggle works
        let toggleText = app.staticTexts["Use phone number?"]
        XCTAssertTrue(toggleText.exists, "The toggle text 'Use phone number?' should exist.")
        
        // Tap toggle
        toggleText.tap()
        
        XCTAssertTrue(app.staticTexts["Use mail address?"].exists, "The toggle text should change to 'Use mail address?'.")
    }
    func test_ResetPassword_Accessibility_Labels(){
        
        let title = app.staticTexts["Reset Password,"]
        XCTAssertTrue(title.exists, "The title 'Reset Password,' should exist.")
        
        let subtitle = app.staticTexts["Now you can create new password and confirm it below."]
        XCTAssertTrue(subtitle.exists, "The subtitle should exist.")
        
        let newPasswordTextField = app.secureTextFields["New password"]
        XCTAssertTrue(newPasswordTextField.exists, "The new password text field should exist.")
        
        let confirmPasswordTextField = app.secureTextFields["Confirm new password"]
        XCTAssertTrue(confirmPasswordTextField.exists, "The confirm new password text field should exist.")
        
        let confirmButton = app.buttons["Confirm New Password"]
        XCTAssertTrue(confirmButton.exists, "The 'Confirm New Password' button should exist.")
    }
    func test_ResetPassword_Accessibility_Values(){
        let newPasswordTextField = app.secureTextFields["New password"]
        XCTAssertTrue(newPasswordTextField.isHittable, "The new password text field should be hittable.")
        
        let confirmPasswordTextField = app.secureTextFields["Confirm new password"]
        XCTAssertTrue(confirmPasswordTextField.isHittable, "The confirm new password text field should be hittable.")
        
        let confirmButton = app.buttons["Confirm New Password"]
        XCTAssertTrue(confirmButton.isHittable, "The 'Confirm New Password' button should be hittable.")
    }
    
    func test_ResetPassword_ErrorMessage_Accessibility() {
        let passwordErrorLabel = app.staticTexts[verificationViewModel.passwordErrorMessage]
        let samePasswordErrorLabel = app.staticTexts[verificationViewModel.samePasswordErrorMessage]
        
        XCTAssertFalse(passwordErrorLabel.exists, "The password error message should not exist initially.")
        XCTAssertFalse(samePasswordErrorLabel.exists, "The same password error message should not exist initially.")
        
        // TEST WRONG PASSWORD
        let newPasswordTextField = app.secureTextFields["New password"]
        newPasswordTextField.tap()
        newPasswordTextField.typeText("short") // Simula una contraseña inválida
        XCTAssertTrue(passwordErrorLabel.exists, "The password error message should appear after entering invalid password.")
        
        // TEST NOT SIMILAR PASSWORDS
        let newPasswordTextField2 = app.secureTextFields["New password"]
        let newConfirmationPasswordTextField = app.secureTextFields["Confirm New password"]
        newPasswordTextField2.tap()
        newPasswordTextField2.typeText("Qwertyu7") // Simula una contraseña valida
        
        newConfirmationPasswordTextField.tap()
        newConfirmationPasswordTextField.typeText("Qwertyu8") // Simular contraseña diferente
        
        XCTAssertTrue(samePasswordErrorLabel.exists, "El mensaje de error de confirmación de contraseña no se muestra correctamente")
    }
    func test_SignIn_ErrorMessage_Accessibility() {
        
        let nameErrorLabel = app.staticTexts[verificationViewModel.nameErrorMessage]
        let emailErrorLabel = app.staticTexts[verificationViewModel.mailErrorMessage]
        let passwordErrorLabel = app.staticTexts[verificationViewModel.passwordErrorMessage]
        let phoneErrorLabel = app.staticTexts[verificationViewModel.phoneErrorMessage]
        
        XCTAssertFalse(nameErrorLabel.exists, "The name error message should not exist initially.")
        XCTAssertFalse(emailErrorLabel.exists, "The email email error message should not exist initially.")
        XCTAssertFalse(passwordErrorLabel.exists, "The password error message should not exist initially.")
        XCTAssertFalse(phoneErrorLabel.exists, "The same phone error message should not exist initially.")
        
        // TEST NAME
        let nameTextField = app.textFields["nameTextField"] // Identificador accesible del campo de nombre
        nameTextField.tap()
        nameTextField.typeText("Jo")
        XCTAssertTrue(nameErrorLabel.exists, "El mensaje de error de longitud de nombre de usuario no se muestra correctamente")
        
        // TEST PHONE NUMBER
        let phoneTextField = app.textFields["phoneTextField"] // Identificador accesible del campo de teléfono
        phoneTextField.tap()
        phoneTextField.typeText("12345")
        XCTAssertTrue(phoneErrorLabel.exists, "El mensaje de error de número de teléfono no se muestra correctamente")
        
        // TEST PASSWORD
        let newPasswordTextField = app.secureTextFields["Password"]
        newPasswordTextField.tap()
        newPasswordTextField.typeText("jeje") // Simula una contraseña inválida
        XCTAssertTrue(passwordErrorLabel.exists, "The password error message should appear after entering invalid password.")
        
        // TEST EMAIL FORMAT
        let emailTextField = app.textFields["emailTextField"] // Identificador accesible del campo de email
        emailTextField.tap()
        emailTextField.typeText("invalid-email") // No @
        XCTAssertTrue(emailErrorLabel.exists, "El mensaje de error de formato de email no se muestra correctamente")
        
        // TEST EMAIL RESTRICTED WORDS
        let emailRestrictedTextField = app.textFields["emailTextField"] // Identificador accesible del campo de email
        emailRestrictedTextField.tap()
        emailRestrictedTextField.typeText("drop@example.com")
        
        XCTAssertTrue(emailErrorLabel.exists, "El mensaje de error de palabras restringidas en el email no se muestra correctamente")
    }
    func test_LogIn_ErrorMessage_Accessibility() {
        
        let emailErrorLabel = app.staticTexts[verificationViewModel.mailErrorMessage]
        let passwordErrorLabel = app.staticTexts[verificationViewModel.passwordErrorMessage]
        
        XCTAssertFalse(emailErrorLabel.exists, "The email email error message should not exist initially.")
        XCTAssertFalse(passwordErrorLabel.exists, "The password error message should not exist initially.")
        
        // TEST PASSWORD
        let newPasswordTextField = app.secureTextFields["Password"]
        newPasswordTextField.tap()
        newPasswordTextField.typeText("jeje") // Simula una contraseña inválida
        XCTAssertTrue(passwordErrorLabel.exists, "The password error message should appear after entering invalid password.")
        
        // TEST EMAIL FORMAT
        let emailTextField = app.textFields["emailTextField"] // Identificador accesible del campo de email
        emailTextField.tap()
        emailTextField.typeText("invalid-email") // No @
        XCTAssertTrue(emailErrorLabel.exists, "El mensaje de error de formato de email no se muestra correctamente")
        
        // TEST EMAIL RESTRICTED WORDS
        let emailRestrictedTextField = app.textFields["emailTextField"] // Identificador accesible del campo de email
        emailRestrictedTextField.tap()
        emailRestrictedTextField.typeText("drop@example.com")
        
        let restrictedWordErrorMessage = app.staticTexts["There is a restricted word in the email"]
        XCTAssertTrue(restrictedWordErrorMessage.exists, "El mensaje de error de palabras restringidas en el email no se muestra correctamente")
        
    }
    
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
